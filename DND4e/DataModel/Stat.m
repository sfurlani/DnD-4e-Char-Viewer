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
        else {
            self.name = [[[info valueForKey:@"alias"] objectAtIndex:0] valueForKey:@"name"];
            self.type = @"Ability";
        }
        
//        NSLog(@"Making Stat: %@ %@", self.name, self.type);
        
        self.level = [[info valueForKey:@"level"] intValue];
        
        // Stat Add
        id addInfo = [info valueForKey:@"statadd"];
//        NSLog(@"statadd: %@",info);
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
//                NSLog(@"Leaf Object: %@ %@ %@", self.name, self.type, self.charelem);
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
    
#define ABILITY_VALUE(key) else if ([self.name isEqualToString:key]) value += [[self.character.scores modifier:key] intValue];
    
    if ([self.name isEqualToString:@"HALF-LEVEL"]) value += [self.statadd count];
    ABILITY_VALUE(keyStrength)
    ABILITY_VALUE(keyConstitution)
    ABILITY_VALUE(keyDexterity)
    ABILITY_VALUE(keyIntelligence)
    ABILITY_VALUE(keyWisdom)
    ABILITY_VALUE(keyCharisma)
    else if ([self.type isEqualToString:@"trained"]) value+=5;
    else if ([self.statadd count] > 0) {
        [self.statadd enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Stat *stat = [self.character.stats objectForKey:obj];
            if (stat) value += [stat value];
            else {
                
                NSNumber *_charelem = NSINT([[obj valueForKey:@"charelem"] intValue]);
                NSString *_type = [obj valueForKey:@"type"];
                // TODO: look for element or items?
                RulesElement *element = [self.character elementForCharelem:_charelem];
                if (element) {
                    NSLog(@"Element1: %@ - %@ %@", element.name, element.type, element.charelem);
                } 
                
                Loot *loot = [self.character lootForCharelem:_charelem];
                if (loot) {
                    NSLog(@"Loot1: %@ - %@", [loot name], _type);
                }
                
                if (!element && !loot)
                    NSLog(@"Can't Find Element1: %@", _charelem);
            }
        }];
    } else {
        if (self.charelem) {
            RulesElement *element = [self.character elementForCharelem:self.charelem];
            if (element) {
                NSLog(@"Element2: %@ - %@ %@", element.name, element.type, element.charelem);
            } 
            
            Loot *loot = [self.character lootForCharelem:self.charelem];
            if (loot) {
                NSLog(@"Loot2: %@", [loot name]);
            }
            
            if (!element && !loot)
             NSLog(@"Can't Find Element2: %@", self.charelem);
        }
    }
//    NSLog(@"%@ (%d) - %@ %@", self.name, value, self.type, self.charelem);
    return value;
}

- (NSString*)html
{
    __block NSMutableString *html = [NSMutableString string];
    
    __block NSString * row = @"<b>%@: </b>%@<br>";
    __block NSString * rowGO = @"<b>%@: </b><a href=\"element://%@\">%@</a><br>";
    __block NSString * rowItem = @"<b>%@: </b><a href=\"item://%@\">%@</a><br>";
    NSString * rowMod = @"<b>%@ Modifier: </b>%@<br>";

#define ABILITY_HTML(key) else if ([self.name isEqualToString:key]) {\
NSNumber *value = [self.character.scores modifier:key]; \
id valueStr = [value intValue] > 0 ? NSFORMAT(@"+%@",value) : value; \
[html appendFormat:rowMod,key,valueStr];\
}
    
    if ([self.name isEqualToString:@"HALF-LEVEL"]) [html appendFormat:row, @"Half-Level", NSFORMAT(@"+%d",[self.statadd count])];
    ABILITY_HTML(keyStrength)
    ABILITY_HTML(keyConstitution)
    ABILITY_HTML(keyDexterity)
    ABILITY_HTML(keyIntelligence)
    ABILITY_HTML(keyWisdom)
    ABILITY_HTML(keyCharisma)
    else if ([self.type isEqualToString:@"trained"]) [html appendFormat:row,@"Trained",@"+5"];
    else if ([self.statadd count] > 0) {
        [self.statadd enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Stat *stat = [self.character.stats objectForKey:obj];
            if (stat) [html appendString:[stat html]];
            else {
                NSNumber *_charelem = NSINT([[obj valueForKey:@"charelem"] intValue]);
                //NSString *_type = [obj valueForKey:@"type"];
                //NSString *_name = [obj valueForKey:@"name"];
                RulesElement *element = [self.character elementForCharelem:_charelem];
                if (element) { // Element 1
                    [html appendFormat:rowGO,element.type,element.charelem,element.name];   
                }
                
                Loot *loot = [self.character lootForCharelem:_charelem];
                if (loot) { // Loot 1
                    [html appendFormat:rowItem,@"Item",_charelem,[loot shortname]];
                }
                
                if (!element && !loot) {
//                    NSLog(@"Can't Find Element1: %@", _charelem);
                }
                
            }
        }];
    }
    else {
        
        if (self.charelem) {
            RulesElement *element = [self.character elementForCharelem:self.charelem];
            if (element) { // Element 2
                [html appendFormat:rowGO,element.type,element.charelem,element.name];
            }
            
            Loot *loot = [self.character lootForCharelem:self.charelem];
            if (loot) { // Loot2
                [html appendFormat:rowItem,@"Item",self.charelem,[loot shortname]];
            }
            
            if (!element && !loot) {
//                NSLog(@"Can't Find Element2: %@", self.charelem);
            }
            
        }
    }
    
    return html;
}

@end
