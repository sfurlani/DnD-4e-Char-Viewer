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
@synthesize stats, scores;

- (id) init
{
    self = [super init];
    if (self) {
        self.stats = [NSMutableDictionary dictionaryWithCapacity:6];
        [self.stats setObject:NSINT(-1) forKey:keyStrength];
        [self.stats setObject:NSINT(-1) forKey:keyConstitution];
        [self.stats setObject:NSINT(-1) forKey:keyDexterity];
        [self.stats setObject:NSINT(-1) forKey:keyIntelligence];
        [self.stats setObject:NSINT(-1) forKey:keyWisdom];
        [self.stats setObject:NSINT(-1) forKey:keyCharisma];
        
        self.scores = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       [[Score alloc] initWithName:keyStrength],keyStrength,
                       [[Score alloc] initWithName:keyConstitution],keyConstitution,
                       [[Score alloc] initWithName:keyDexterity],keyDexterity,
                       [[Score alloc] initWithName:keyIntelligence],keyIntelligence,
                       [[Score alloc] initWithName:keyWisdom],keyWisdom,
                       [[Score alloc] initWithName:keyCharisma],keyCharisma,
                       nil];
        
        
        
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
            [self.stats setObject:NSINT([[obj valueForKey:@"score"] intValue]) forKey:key];
    }];
    
    [statBlock enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [[[obj valueForKey:@"alias"] objectAtIndex:0] valueForKey:@"name"];
        __block Score *score = [self.scores valueForKey:key];
        
        if (score) {
            NSArray *components = [obj valueForKey:@"statadd"];
            [components enumerateObjectsUsingBlock:^(id com, NSUInteger idx, BOOL *stop) {
                NSDictionary *component = com;
                if ([component count] > 1) {
                    [score.components addObject:component];
                }
            }];
        } else {
            NSLog(@"No Score for  key: %@", key);
        }
        
        
    }];
    
}


- (NSString*) name
{
    return @"Ability Scores";
}

- (NSString*) html
{
    NSMutableString *html = [NSMutableString string];
    
    [html appendFormat:@"<p><b>STR: </b> %@</p>",[self.stats objectForKey:keyStrength]];
    [html appendFormat:@"<p><b>CON: </b> %@</p>",[self.stats objectForKey:keyConstitution]];
    [html appendFormat:@"<p><b>DEX: </b> %@</p>",[self.stats objectForKey:keyDexterity]];
    [html appendFormat:@"<p><b>INT: </b> %@</p>",[self.stats objectForKey:keyIntelligence]];
    [html appendFormat:@"<p><b>WIS: </b> %@</p>",[self.stats objectForKey:keyWisdom]];
    [html appendFormat:@"<p><b>CHA: </b> %@</p>",[self.stats objectForKey:keyCharisma]];
    [html appendString:@"<hr width=\"200\">"];
    
    return html;
}

@end

@implementation Score

@synthesize name = _name, aliases, parent, components;

- (id) initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (NSString*) html
{
    // TODO: populate
    return @"nothing for now";
}

@end
