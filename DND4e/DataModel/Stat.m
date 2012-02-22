//
//  Stat.m
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "Stat.h"
#import "Data.h"
#import "Utility.h"

@implementation Stat

@synthesize name, level, charelem, type, statadd, character;
@synthesize info = _info;

- (id) initWithDictionary:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.info = info;
        
        // Alias
        if ([[info valueForKey:@"alias"] isKindOfClass:[NSDictionary class]])
            self.name = [info valueForKeyPath:@"alias.name"];
        else 
            self.name = [[[info valueForKey:@"alias"] objectAtIndex:0] valueForKey:@"name"];
        
        NSLog(@"Making Stat: %@", self.name);
        
        self.level = [[info valueForKey:@"level"] intValue];
        
        // Stat Add
        id addInfo = [info valueForKey:@"statadd"];
        NSLog(@"statadd: %@",addInfo);
        NSMutableArray *addMut = [NSMutableArray arrayWithCapacity:[addInfo count]];
        if (addInfo) {
            if (![addInfo isKindOfClass:[NSDictionary class]]) {
                [addInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSString *link = [obj valueForKeyPath:@"statlink"];
                    if (link) {
                        [addMut addObject:link];
                    } else
                        [addMut addObject:obj];
                }];
                self.charelem = NSINT([[info valueForKey:@"charelem"] intValue]);
                self.type = [info valueForKey:@"type"];
            } else {
                // Leaf Object
                self.charelem = NSINT([[addInfo valueForKey:@"charelem"] intValue]);
                self.type = [addInfo valueForKey:@"type"];
                NSLog(@"Leaf Object: %@ %@ %@", self.name, self.type, self.charelem);
            }
        } else {
            
        }
        self.statadd = addMut;
        
        
    }
    return self;
}

- (NSInteger)value
{
    __block NSInteger value = 0;
    if ([self.name isEqualToString:@"HALF-LEVEL"]) value += [self.statadd count];
    else if ([self.type isEqualToString:@"Ability"]) {NSLog(@"Go Get: %@", self.name);}
    else if ([self.type isEqualToString:@"trained"]) value+=5;
    else if ([self.statadd count] > 0) {
        [self.statadd enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Stat *stat = [self.character.stats objectForKey:obj];
            if (stat) value += [stat value];
            else {
                // Attribute Block
                NSNumber *_charelem = NSINT([[obj valueForKey:@"charelem"] intValue]);
                RulesElement *element = [self.character elementForCharelem:_charelem];
                if (element) {
                    NSLog(@"Element1: %@ - %@ %@", element.name, element.type, element.charelem);
                    if ([element.type isEqualToString:@"Race Ability Bonus"]) value+=2;
                    else if ([element.type rangeOfString:@"Ability Increase"].length > 0) value+=1;
                    else if ([element.type rangeOfString:@"Level"].length > 0) value+=1;
                } else {
                    value += ([[self.character.scores.stats objectForKey:self.name] intValue]-10)/2;
                }
            }
        }];
    } 
    else {
        if (self.charelem) {
            RulesElement *element = [self.character elementForCharelem:self.charelem];
            if (element) {
                NSLog(@"Element2: %@ - %@ %@", element.name, element.type, element.charelem);
                
            } else NSLog(@"No Element: %@", self.charelem);
        }
    }
    NSLog(@"%@ (%d) - %@ %@", self.name, value, self.type, self.charelem);
    return value;
}

- (NSString*)html
{
    __block NSMutableString *html = [NSMutableString string];
    
    __block NSString * row = @"<b>%@: </b>%@<br>";
    
    if ([self.name isEqualToString:@"HALF-LEVEL"]) [html appendFormat:row, @"Half-Level", NSFORMAT(@"+%d",[self.statadd count])];
    else if ([self.type isEqualToString:@"Ability"]) [html appendFormat:row,@"Stat (TODO:)",self.name];
    else if ([self.type isEqualToString:@"trained"]) [html appendFormat:row,@"Trained",@"+5"];
    else if ([self.statadd count] > 0) {
        [self.statadd enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Stat *stat = [self.character.stats objectForKey:obj];
            if (stat) [html appendString:[stat html]];
            else {
                NSNumber *_charelem = NSINT([[obj valueForKey:@"charelem"] intValue]);
                RulesElement *element = [self.character elementForCharelem:_charelem];
                if (element) {
                    [html appendFormat:row,element.type,element.name];   
                } else {
                    int mod = ([[self.character.scores.stats objectForKey:self.name] intValue]-10)/2;
                    if (mod > 0)
                        [html appendFormat:@"<b>%@ Modifier: </b>+%d<br>",self.name, mod];
                    else
                        [html appendFormat:@"<b>%@ Modifier: </b>%d<br>",self.name, mod];
                }
            }
        }];
    }
    else {
        if (self.charelem) {
            RulesElement *element = [self.character elementForCharelem:self.charelem];
            if (element) {
                [html appendFormat:row,element.type,element.name];
            }
        }
    }
    
    return html;
}

@end
