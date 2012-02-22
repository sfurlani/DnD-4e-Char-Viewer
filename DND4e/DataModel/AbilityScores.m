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
    NSDictionary *abilityScores = [info valueForKeyPath:@"AbilityScores"];
    NSArray *statBlock = [info valueForKeyPath:@"StatBlock.Stat"];
    
    [abilityScores enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]])
            [self.base setObject:NSINT([[obj valueForKey:@"score"] intValue]) forKey:key];
    }];
    
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
    "<td align=\"center\">%d</td>"
    "<td align=\"center\">%@</td>"
    "<td align=\"center\">%@</td>"
    "</tr>";
    
    __block NSString * tableRowGrey = @"<tr valign=\"middle\" bgcolor=\"#EEE\">"
    "<td align=\"left\">%@:</td>"
    "<td align=\"center\">%d</td>"
    "<td align=\"center\">%@</td>"
    "<td align=\"center\">%@</td>"
    "</tr>";
    
    __block int count = 0;
    
    void (^printOut)(NSString*) = ^(NSString* key){
        count++;
        NSString * row = (count%2 == 0) ? tableRow : tableRowGrey;
        
        NSInteger score = [[self.base objectForKey:key] intValue];
        NSInteger mod = (score - 10)/2;
        NSInteger check = mod + [character.level intValue]/2;
        
        // TODO: Check for modifiers!!!
        NSString *modStr = (mod > 0) ? NSFORMAT(@"+%d", mod) : NSFORMAT(@"%d", mod);
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
    
    return html;
}

@end
