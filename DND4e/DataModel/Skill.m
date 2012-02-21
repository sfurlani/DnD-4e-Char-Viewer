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
@synthesize character;
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
