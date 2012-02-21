//
//  Skill.m
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "Skill.h"
#import "Data.h"
#import "Utility.h"

@implementation Skill

@synthesize name = _name;
@synthesize character = _character;
@synthesize components;
@synthesize bonus = _bonus;

- (id) initWithName:(NSString*)name
{
    self = [super init];
    if (self) {
        self.name = name;
        self.components = nil;
    }
    return self;
}

- (void) populateFromElements:(NSArray*)elements
{
    // Performed using Elements
    self.components = [elements objectsAtIndexes:[elements indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        RulesElement *ele = obj;
        return ([ele.name hasPrefix:self.name] ||
                ([ele.type hasPrefix:@"Skill"] && [ele.name rangeOfString:self.name].length > 0));
    }]];
    
    __block NSInteger bonus = [self.character.level intValue]/2;
    [self.components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RulesElement *ele = obj;
        if ([ele.type isEqualToString:@"Skill Training"]) bonus += 5;
        if ([ele.type isEqualToString:@"Racial Trait"]) bonus += 2;
        if ([ele.type isEqualToString:@"Background Choice"]) bonus += 2;
        if ([ele.type isEqualToString:@"Skill"]) {
            [ele.specifics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([[obj valueForKey:@"name"] hasPrefix:@"Key"]) {
                    NSNumber *stat = [self.character.stats.stats objectForKey:[obj valueForKey:@"value"]];
                    NSInteger mod = ([stat intValue]-10)/2;
                    bonus += mod;
                }
            }];
        }
        NSLog(@"%@ %@ %d", self.name, ele.type, bonus);
    }];
    self.bonus = NSINT(bonus);
}

- (void) populateFromCharacter:(Character*)character
{
    self.character = character;
    NSDictionary *stats = character.stats.stats;
    Score *stat = [stats objectForKey:self.name];
    __block NSInteger bonus = 0;
    NSLog(@"Stat: %@", stat.name);
    [stat.components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *statlink = [obj valueForKey:@"statlink"];
        NSString *type = [obj valueForKey:@"type"];
        NSInteger level = [[obj valueForKey:@"Level"] intValue];
        
        Score *st = [stats objectForKey:statlink];
        if ([st.name isEqualToString:@"HALF-LEVEL"]) bonus += [st.components count];
        else if ([type isEqualToString:@"Ability"]) { NSLog(@"TODO: Add Ability: %@",st.name); }
        else if ([st.name rangeOfString:@"Trained"].length > 0) bonus +=5;
        else if ([st.
        else {
            NSLog(@"Component: %@", statlink);
            Score *comp = [stats objectForKey:statlink];
            NSLog(@"Data: %@", comp.components);
        }
        
    }];
    
    NSLog(@"Bonus: %d", bonus);
            self.bonus = NSINT(bonus);
}


- (NSString*) html
{
    __block NSMutableString *html = [NSMutableString string];
    
    if ([self.bonus intValue] > 0)
        [html appendFormat:@"<b>Bonus:</b> +%@<br>",self.bonus];
    else
        [html appendFormat:@"<b>Bonus:</b> %@<br>",self.bonus];
    
    [self.components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [html appendFormat:@"%@<br>",[obj html]]; 
    }];
    
    return html;
}

@end
