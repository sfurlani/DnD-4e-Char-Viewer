//
//  Character.m
//  DND4e
//
//  Created by Stephen Furlani on 2/20/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "Character.h"
#import "Data.h"
#import "XMLReader.h"
#import "Utility.h"

@implementation Character

@synthesize name, level;
@synthesize powers, loot;
@synthesize objectGraph;
@synthesize details, stats, elements, scores;
@synthesize skills, feats, features;

- (id) initWithFile:(NSString *)path
{
    self = [super init];
    if (self) {
        NSData *xmlData = [[NSData alloc] initWithContentsOfFile:path];
        NSError *error = nil;
        NSDictionary *data = [XMLReader dictionaryForXMLData:xmlData error:&error];
        
        NSArray *powerInfo = [data valueForKeyPath:@"D20Character.CharacterSheet.PowerStats.Power"];
        self.powers = [NSMutableArray arrayWithCapacity:[powerInfo count]];
        [powerInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Power *power = [[Power alloc] initWithDictionary:obj];
            [self.powers addObject:power];
            power.character = self; // weak
        }];
        
        NSArray *lootInfo = [data valueForKeyPath:@"D20Character.CharacterSheet.LootTally.loot"];
        self.loot = [NSMutableArray arrayWithCapacity:[lootInfo count]];
        [lootInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Loot *item = [[Loot alloc] initWithDictionary:obj];
            [self.loot addObject:item];
            item.character = self; // weak
        }];
        
        self.name = [data valueForKeyPath:@"D20Character.CharacterSheet.Details.name.value"];
        self.level = NSINT([[data valueForKeyPath:@"D20Character.CharacterSheet.Details.Level.value"] intValue]);
        
        self.objectGraph = [data valueForKeyPath:@"D20Character"];
        
        NSDictionary *detailInfo = [data valueForKeyPath:@"D20Character.CharacterSheet.Details"];
        self.details = [NSMutableDictionary dictionaryWithCapacity:[detailInfo count]];
        [detailInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *value = [obj valueForKey:@"value"];
                [self.details setObject:value forKey:key];
            } else {
                NSLog(@"No Value for %@, %@", key, obj);
            }
            
        }];
        
        NSArray *statInfo = [data valueForKeyPath:@"D20Character.CharacterSheet.StatBlock.Stat"];
        self.stats = [NSMutableDictionary dictionaryWithCapacity:[statInfo count]];
        [statInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Stat *stat = [[Stat alloc] initWithDictionary:obj];
            stat.character = self;
            [self.stats setObject:stat forKey:stat.name];
        }];
        
        self.scores = [[AbilityScores alloc] init];
        self.scores.character = self;
        [self.scores populateWithDictionary:[data valueForKeyPath:@"D20Character.CharacterSheet.AbilityScores"]];
        
        NSArray *elementInfo = [data valueForKeyPath:@"D20Character.CharacterSheet.RulesElementTally.RulesElement"];
        self.elements = [NSMutableArray arrayWithCapacity:[elementInfo count]];
        [elementInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RulesElement *element = [[RulesElement alloc] initWithDictionary:obj];
            [self.elements addObject:element];
        }];
        
        NSArray *skillObjs = [[self.elements objectsAtIndexes:[self.elements indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [[(RulesElement*)obj type] isEqualToString:@"Skill"];
        }]] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 name] caseInsensitiveCompare:[obj2 name]];
        }];
        
        self.skills = [NSMutableArray arrayWithCapacity:[skillObjs count]];
        [skillObjs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Skill *skill = [[Skill alloc] initWithName:[obj name]];
//            [skill populateFromElements:self.elements];
            [skill populateFromCharacter:self];
            [self.skills addObject:skill];
        }];
        
        self.feats = [[self.elements objectsAtIndexes:[self.elements indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [[(RulesElement*)obj type] isEqualToString:@"Feat"];
        }]] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 name] caseInsensitiveCompare:[obj2 name]];
        }];
        
        self.features = [[self.elements objectsAtIndexes:[self.elements indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return ([[(RulesElement*)obj type] rangeOfString:@"Feature"].length > 0);
        }]] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 name] caseInsensitiveCompare:[obj2 name]];
        }];
        
    }
    return self;
}

- (NSString*) html
{
    NSMutableString *html = [NSMutableString string];
    
    [self.details enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
             
        [html appendFormat:@"<p><b>%@: </b>%@</p>",key, obj];
        
    }];
    
    return html;
}

- (Loot*) lootForInternalID:(NSString*)internalID
{
    __block Loot *ret = nil;
    [self.loot enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Loot *lt = obj;
        [lt.items enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx, BOOL *stop) {
            Item *it = obj2;
            if ([it.element.internal_id isEqualToString:internalID]) {
                ret = obj;
                *stop = YES;
            }
        }];
        if (ret) *stop = YES;
    }];
    return ret;
}

- (RulesElement*) elementForCharelem:(NSNumber*)charElem
{
    __block RulesElement *elem = nil;
    [self.elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([charElem isEqualToNumber:[obj charelem]]) {
            *stop = YES;
            elem = obj;
        }
    }];
    return elem;
}

@end
