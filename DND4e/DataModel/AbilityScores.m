//
//  AbilityScores.m
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "AbilityScores.h"
#import "Data.h"
#import "Utility.h"

NSString * const keyStrength = @"Strength";
NSString * const keyConstitution = @"Constitution";
NSString * const keyDexterity = @"Dexterity";
NSString * const keyIntelligence = @"Intelligence";
NSString * const keyWisdom = @"Wisdom";
NSString * const keyCharisma = @"Charisma";

@implementation AbilityScores

@synthesize character;
@synthesize base, stats;

- (id) init
{
    self = [super init];
    if (self) {
        self.base = [NSMutableDictionary dictionaryWithCapacity:6];
        [self.base setObject:NSINT(-1) forKey:keyStrength];
        [self.base setObject:NSINT(-1) forKey:keyConstitution];
        [self.base setObject:NSINT(-1) forKey:keyDexterity];
        [self.base setObject:NSINT(-1) forKey:keyIntelligence];
        [self.base setObject:NSINT(-1) forKey:keyWisdom];
        [self.base setObject:NSINT(-1) forKey:keyCharisma];
        
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary*)info
{
    self = [self init];
    if (self) {
        [self populateWithDictionary:info];
    }
    return self;
}

- (void) populateWithDictionary:(NSDictionary*)info
{
    NSDictionary *abilityScores = info;
    NSParameterAssert(self.character != nil);
    
    // Base Ability Scores
    [abilityScores enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]])
            [self.base setObject:NSINT([[obj valueForKey:@"score"] intValue]) forKey:key];
    }];
    
}

- (NSNumber*) score:(NSString *)ability
{
    NSInteger baseScore = [[self.base objectForKey:ability] intValue];
    Stat *stat = [self.character.stats objectForKey:ability];
    __block NSInteger value = 0;
    [stat.statadd enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // Attribute Block
        NSNumber *_charelem = NSINT([[obj valueForKey:@"charelem"] intValue]);
        RulesElement *element = [self.character elementForCharelem:_charelem];
        if (element) {
            if ([element.type isEqualToString:@"Race Ability Bonus"]) value+=2;
            else if ([element.type rangeOfString:@"Ability Increase"].length > 0) value+=1;
            else if ([element.type rangeOfString:@"Level"].length > 0) value+=1;
            else {
                NSLog(@"Unknown Ability Score: %@ - %@ %@", element.name, element.type, element.charelem);
            }
        }
    }];
//    NSLog(@"Base Score: %d Value: %d", baseScore, value);
    return NSINT(baseScore+value);
}

- (NSNumber*) modifier:(NSString *)ability
{
    return NSINT(([[self score:ability] intValue] - 10)/2);
}


- (NSString*) name
{
    return @"Ability Scores";
}

- (NSString*) html
{
    NSMutableString *html = [NSMutableString string];
    
    [html appendString:@"<table border=\"0\" width=\"100%\" style=\"margin: 0px;\" CELLPADDING=5 CELLSPACING=0>"];
    [html appendString:@"<tr valign=\"middle\">"
     "<th align=\"left\">Ability</th>"
     "<th align=\"center\">Score</th>"
     "<th align=\"center\">Mod</th>"
     "<th align=\"center\">Check</th>"
     "</tr>"];
    
    __block NSString * tableRow = @"<tr valign=\"middle\">"
    "<td align=\"left\">%@:</td>"
    "<td align=\"center\">%@</td>"
    "<td align=\"center\">%@</td>"
    "<td align=\"center\">%@</td>"
    "</tr>";
    
    __block NSString * tableRowGrey = @"<tr valign=\"middle\" bgcolor=\"#EEE\">"
    "<td align=\"left\">%@:</td>"
    "<td align=\"center\">%@</td>"
    "<td align=\"center\">%@</td>"
    "<td align=\"center\">%@</td>"
    "</tr>";
    
    __block int count = 0;
    
    void (^printOut)(NSString*) = ^(NSString* key){
        count++;
        NSString * row = (count%2 == 0) ? tableRow : tableRowGrey;
        
        NSNumber *score = [self score:key];
        NSNumber *mod = [self modifier:key];
        NSInteger check = [mod intValue] + [character.level intValue]/2;
        
        // TODO: Check for modifiers!!!
        NSString *modStr = ([mod intValue] > 0) ? NSFORMAT(@"+%@", mod) : NSFORMAT(@"%@", mod);
        NSString *checkStr = (check > 0) ? NSFORMAT(@"+%d", check) : NSFORMAT(@"%d", check);
        
        [html appendFormat:row,key,score,modStr,checkStr];

    };
    
    printOut(keyStrength);
    printOut(keyConstitution);
    printOut(keyDexterity);
    printOut(keyIntelligence);
    printOut(keyWisdom);
    printOut(keyCharisma);
    
    [html appendString:@"</table>"];
    
    [html appendString:@"<hr width=\"200\">"];
    
//    NSString *link = @"<a href=\"stat://%@\">%@ Details</a><br>";
//    
//    [html appendFormat:link,keyStrength,keyStrength];
//    [html appendFormat:link,keyConstitution,keyConstitution];
//    [html appendFormat:link,keyDexterity,keyDexterity];
//    [html appendFormat:link,keyIntelligence,keyIntelligence];
//    [html appendFormat:link,keyWisdom,keyWisdom];
//    [html appendFormat:link,keyCharisma,keyCharisma];
    
    return html;
}

@end
