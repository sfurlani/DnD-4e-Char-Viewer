//
//  AbilityScores.m
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
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
    Stat *stat = [self.character.stats objectForKey:ability];
    return NSINT([stat._value intValue]);
}

- (NSNumber*) modifier:(NSString *)ability
{
    return NSINT(([[self score:ability] intValue] - 10)/2);
}


- (NSString*) name
{
    return self.character.name;
}

//- (NSString*) html
//{
//    NSMutableString *html = [NSMutableString string];
//    
//    [html appendString:@"<table border=\"0\" width=\"100%\" style=\"margin: 0px;\" CELLPADDING=5 CELLSPACING=0>"];
//    [html appendString:@"<tr valign=\"middle\">"
//     "<th align=\"left\">Ability</th>"
//     "<th align=\"center\">Score</th>"
//     "<th align=\"center\">Mod</th>"
//     "<th align=\"center\">Check</th>"
//     "</tr>"];
//    
//    __block NSString * tableRow = @"<tr valign=\"middle\">"
//    "<td align=\"left\"><a href=\"abil://%@\">%@:</a></td>"
//    "<td align=\"center\">%@</td>"
//    "<td align=\"center\">%@</td>"
//    "<td align=\"center\">%@</td>"
//    "</tr>";
//    
//    __block NSString * tableRowGrey = @"<tr valign=\"middle\" bgcolor=\"#EEE\">"
//    "<td align=\"left\"><a href=\"abil://%@\">%@:</a></td>"
//    "<td align=\"center\">%@</td>"
//    "<td align=\"center\">%@</td>"
//    "<td align=\"center\">%@</td>"
//    "</tr>";
//    
//    __block int count = 0;
//    
//    __block Stat *halfLevel = [self.character.stats objectForKey:@"HALF-LEVEL"];
//    
//    void (^printOut)(NSString*) = ^(NSString* key){
//        count++;
//        NSString * row = (count%2 == 0) ? tableRow : tableRowGrey;
//        
//        Stat *score = [self.character.stats objectForKey:key];
//        Stat *mod = [self.character.stats objectForKey:NSFORMAT(@"%@ modifier", key)];
//        NSInteger check = [halfLevel._value intValue] + [mod._value intValue];
//        
//        [html appendFormat:row,key,key,score._value,PFORMAT(mod._value),NFORMAT(check)];
//
//    };
//    
//    printOut(keyStrength);
//    printOut(keyConstitution);
//    printOut(keyDexterity);
//    printOut(keyIntelligence);
//    printOut(keyWisdom);
//    printOut(keyCharisma);
//    
//    [html appendString:@"</table>"];
//    
//    [html appendString:@"<hr width=\"200\">"];
//    
//    NSString *row = @"<b><a href=\"stat://%@\">%@:</a></b><t> %@<br>";
//    /*
//     AC
//     Fortitude Defense
//     Will Defense
//     Reflex Defense
//     Level
//     Hit Points
//     Healing Surges
//     Initiative
//     XP Needed
//     Passive Perception
//     Passive Insight
//     Speed
//     Saving Throws
//     
//     */
//    
//#define ABILITY_HTML(stat) [html appendFormat:row,stat,stat,[[self.character.stats objectForKey:stat] _value]]
//    
//    ABILITY_HTML(@"AC");
//    ABILITY_HTML(@"Fortitude Defense");
//    ABILITY_HTML(@"Reflex Defense");
//    ABILITY_HTML(@"Will Defense");
//    ABILITY_HTML(@"Hit Points");
//    ABILITY_HTML(@"Healing Surges");
//    ABILITY_HTML(@"Initiative");
//    ABILITY_HTML(@"Speed");
//    ABILITY_HTML(@"Passive Perception");
//    ABILITY_HTML(@"Passive Insight");
//    
//    
//    return html;
//}

- (NSString*)html
{
    NSMutableString *html = [NSMutableString string];
    
    [html appendString:@"<table border=\"0\" width=\"100%\" style=\"margin: 0px;\" CELLPADDING=5 CELLSPACING=0>"];
    [html appendString:@"<tr valign=\"middle\">"
     "<th align=\"left\">Stat</th>"
     "<th align=\"center\">Value</th>"
     "</tr>"];
    
    __block NSString * tableRow = @"<tr valign=\"middle\">"
    "<td align=\"left\"><a href=\"stat://%@\">%@:</a></td>"
    "<td align=\"center\">%@</td>"
    "</tr>";
    
    __block NSString * tableRowGrey = @"<tr valign=\"middle\" style=\"background-color:rgba(44,44,44,.12)\">"
    "<td align=\"left\"><a href=\"stat://%@\">%@:</a></td>"
    "<td align=\"center\">%@</td>"
    "</tr>";
    
    __block int count = 0;
    
    void (^printOut)(NSString*, NSString*) = ^(NSString* stat, NSString* name){
        count++;
        NSString * row = (count%2 == 0) ? tableRow : tableRowGrey;
        
        [html appendFormat:row,stat,name,[[self.character.stats objectForKey:stat] _value]];
        
    };
    
    printOut(@"AC",@"AC");
    printOut(@"Fortitude Defense",@"Fortitude");
    printOut(@"Reflex Defense",@"Reflex");
    printOut(@"Will Defense",@"Will");
    [html appendString:@"<tr/>"]; count = 0;
    printOut(@"Hit Points",@"Hit Points");
    printOut(@"Healing Surges",@"Surges");
    [html appendString:@"<tr/>"]; count = 0;
    printOut(@"Speed",@"Speed");
    printOut(@"Initiative",@"Initiative");
    [html appendString:@"<tr/>"]; count = 0;
    printOut(@"Passive Perception", @"Pass. Perception");
    printOut(@"Passive Insight", @"Pass. Insight");
    
//    ABILITY_HTML(@"AC");
//    ABILITY_HTML(@"Fortitude Defense");
//    ABILITY_HTML(@"Reflex Defense");
//    ABILITY_HTML(@"Will Defense");
//    ABILITY_HTML(@"Hit Points");
//    ABILITY_HTML(@"Healing Surges");
//    ABILITY_HTML(@"Initiative");
//    ABILITY_HTML(@"Speed");
//    ABILITY_HTML(@"Passive Perception");
//    ABILITY_HTML(@"Passive Insight");
    
    [html appendString:@"</table>"];
    
//    [html appendString:@"<hr width=\"200\">"];
    
//    NSString *row = @"<b><a href=\"stat://%@\">%@:</a></b><t> %@<br>";
    /*
     AC
     Fortitude Defense
     Will Defense
     Reflex Defense
     Level
     Hit Points
     Healing Surges
     Initiative
     XP Needed
     Passive Perception
     Passive Insight
     Speed
     Saving Throws
     
     */
    
#define ABILITY_HTML(stat) [html appendFormat:row,stat,stat,[[self.character.stats objectForKey:stat] _value]]
    
    
    
    
    return html;
}

- (NSString*) htmlAbil:(NSString*)key
{
    NSMutableString *html = [NSMutableString string];
    
    [html appendString:[self.character.stats objectForKey:key]];
    
    return html;
}

@end
