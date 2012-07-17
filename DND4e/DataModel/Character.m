//
//  Character.m
//  DND4e
//
//  Created by Stephen Furlani on 2/20/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
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
@synthesize skills, feats, features, traits;

- (id) initWithFile:(NSString *)path
{
    self = [super init];
    if (self) {
        NSData *xmlData = [[NSData alloc] initWithContentsOfFile:path];
        NSError *error = nil;
        NSDictionary *data = [XMLReader dictionaryForXMLData:xmlData error:&error];
        
        self.name = [[data valueForKeyPath:@"D20Character.CharacterSheet.Details.name"] valueForKey:kXMLReaderTextNodeKey];
        self.level = NSINT([[[data valueForKeyPath:@"D20Character.CharacterSheet.Details.Level"] valueForKey:kXMLReaderTextNodeKey] intValue]);
        
        self.objectGraph = [data valueForKeyPath:@"D20Character"];
        
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
            // Only add if the item count > 0 (Sheet does not delete removed items... soooo odd.)
            if ([item.numCount intValue] > 0) {
                [self.loot addObject:item];
                item.character = self; // weak
                if ([item isMagic]) {
                    [self.powers addObject:item];
                }
            }
        }];
        
        NSDictionary *detailInfo = [data valueForKeyPath:@"D20Character.CharacterSheet.Details"];
        self.details = [NSMutableDictionary dictionaryWithCapacity:[detailInfo count]];
        [detailInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *value = [obj valueForKey:kXMLReaderTextNodeKey];
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
            element.character = self;
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
        [self.skills sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 name] caseInsensitiveCompare:[obj2 name]];
        }];
        
        self.feats = [[self.elements objectsAtIndexes:[self.elements indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [[(RulesElement*)obj type] isEqualToString:@"Feat"];
        }]] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 name] caseInsensitiveCompare:[obj2 name]];
        }];
        
        self.features = [[self.elements objectsAtIndexes:[self.elements indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//            NSLog(@"Element Type: %@", [(RulesElement*)obj type]);
            return (([[(RulesElement*)obj type] rangeOfString:@"Class"].length > 0) || 
                    ([[(RulesElement*)obj type] isEqualToString:@"Background"]) ||  // Exact
                    ([[(RulesElement*)obj type] isEqualToString:@"Background Choice"]) || // Exact
                    ([[(RulesElement*)obj type] rangeOfString:@"Paragon Path"].length > 0) || 
                    ([[(RulesElement*)obj type] rangeOfString:@"Epic Destiny"].length > 0) ||
                    ([[(RulesElement*)obj type] rangeOfString:@"Role"].length > 0) ||
                    ([[(RulesElement*)obj type] rangeOfString:@"Power Source"].length > 0) ||
                    ([[(RulesElement*)obj type] rangeOfString:@"Diety"].length > 0) );
        }]] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 name] caseInsensitiveCompare:[obj2 name]];
        }];
        //        NSArray *class = [self elementsForKey:@"type" matchingValue:@"Class" exact:NO];
        //        [self.features addObjectsFromArray:class];
        
        self.traits = [[[self.elements objectsAtIndexes:[self.elements indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            //            NSLog(@"Element Type: %@", [(RulesElement*)obj type]);
            return (([[(RulesElement*)obj type] rangeOfString:@"Trait"].length > 0) || 
                    ([[(RulesElement*)obj type] rangeOfString:@"Race"].length > 0) ||
                    ([[(RulesElement*)obj type] rangeOfString:@"Gender"].length > 0) || 
                    ([[(RulesElement*)obj type] rangeOfString:@"Size"].length > 0) ||
                    ([[(RulesElement*)obj type] rangeOfString:@"Vision"].length > 0) ||
                    ([[(RulesElement*)obj type] rangeOfString:@"Alignment"].length > 0) ||
                    ([[(RulesElement*)obj type] rangeOfString:@"Language"].length > 0) );
        }]] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 name] caseInsensitiveCompare:[obj2 name]];
        }] mutableCopy];
        
        // TODO: Types not accounted for:
        /*
         Gender
         Alignment
         Background*
         Race
         Size
         Vision
         Language
         Internal
         CountsAsClass
         Role
         PowerSource
         Proficiency (loooong list)
         Skill Training
         Paragon Path
         Diety (Domains - InternalIDs)
         Epic Destiny
         */
        
    }
    return self;
}

- (NSString*) html
{
    NSMutableString *html = [NSMutableString string];
    
    [html appendString:@"<dl>"];
    __block int count = 1;
    __block NSString *row = @"<dt><b>%@:</b> %@</dt>";
    __block NSString *rowG = @"<dt style=\"background-color:rgba(44,44,44,.12)\"><b>%@:</b> %@</dt>";
    #define rowColor ((count++)%2 == 0 ? row : rowG)
    [self.details enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [html appendFormat:rowColor,key, obj];
        
    }];
    [html appendString:@"</dl>"];
    
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

- (RulesElement*) elementForInternalID:(NSString*)internalID
{
    __block RulesElement *elem = nil;
    [self.elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([internalID isEqualToString:[obj internal_id]]) {
            *stop = YES;
            elem = obj;
        }
    }];
    return elem;
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

- (Loot*) lootForCharelem:(NSNumber*)charElem
{
    __block Loot *ret = nil;
    [self.loot enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Loot *lt = obj;
        [lt.items enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx, BOOL *stop) {
            Item *it = obj2;
            if ([it.element.charelem isEqualToNumber:charElem]) {
                ret = obj;
                *stop = YES;
            }
        }];
        if (ret) *stop = YES;
    }];
    return ret;
}

- (NSArray*) elementsForKey:(NSString*)key matchingValue:(NSString*)value exact:(BOOL)exact
{
    
    NSIndexSet * indexes = [self.elements indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        RulesElement *element = obj;
        
        id val = [element valueForKey:key];
        if (!val) {
            NSUInteger index = [element.specifics indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                if ([key caseInsensitiveCompare:[obj valueForKey:@"name"]] == NSOrderedSame) *stop = YES;
                return *stop;
            }];
            if (index != NSNotFound) {
                val = [[element.specifics objectAtIndex:index] valueForKey:kXMLReaderTextNodeKey];
            }
        }
        
        if (val) {
            if (exact) {
                return ([val isEqualToString:value]);
            } else {
                return ([val rangeOfString:value].length > 0);
            }
        }
        
        return NO;
    }];
    
    return ([indexes count] > 0 ? [self.elements objectsAtIndexes:indexes] : nil);
}

@end
