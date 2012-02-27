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
@synthesize _value;

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
//            self.type = @"Ability";
        }
        
        
//        NSLog(@"Stat: %@, info: %@", self.name, info);
        
        self.level = [[info valueForKey:@"level"] intValue];
        self._value = [info valueForKey:@"value"];
        self.charelem = NSINT([[info valueForKey:@"charelem"] intValue]);
        self.type = [info valueForKey:@"type"];
        
        // Stat Add
        id addInfo = [info valueForKey:@"statadd"];
//        NSLog(@"statadd: %@",info);
        NSMutableArray *addMut = [NSMutableArray arrayWithCapacity:[addInfo count]];
        if (addInfo) {
            if (![addInfo isKindOfClass:[NSDictionary class]]) {
                [addInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSString *link = [obj valueForKeyPath:@"statlink"];
                    if (link) {
                        if ([link isEqualToString:keyStrength] ||
                            [link isEqualToString:keyConstitution] ||
                            [link isEqualToString:keyDexterity] ||
                            [link isEqualToString:keyIntelligence] ||
                            [link isEqualToString:keyWisdom] ||
                            [link isEqualToString:keyCharisma] )  {
                            NSString *abilMod = [obj valueForKey:@"abilmod"];
                            if (abilMod)
                                link = [link stringByAppendingString:@" modifier"];
                        }
//                        NSLog(@"--- Link: %@", link);
                        [addMut addObject:link];
                    } else {
                        if ([obj count] > 1) {
                            
                            if ([obj valueForKey:@"type"]) {
//                                NSLog(@"--- Leaf Stat: %@ (%@)", [obj valueForKey:@"type"], [obj valueForKey:@"value"]);
                            } else {
//                                NSLog(@"--- Leaf Elem: %@ (%@)", [obj valueForKey:@"charelem"], [obj valueForKey:@"value"]);
                            }
                            [addMut addObject:obj];
                        }
                    }
                }];
            } else {
                // Leaf Object
                self.charelem = NSINT([[addInfo valueForKey:@"charelem"] intValue]);
                self.type = [addInfo valueForKey:@"type"];
//                NSLog(@"+++ Leaf: %@, info: %@", self.name, addInfo);
                
                id mod = [addInfo valueForKey:@"abilmod"];
                if (mod && (mod != [NSNull null])) {
                    self.type = @"Ability";
                } else {
                    self._value = [addInfo valueForKey:@"value"];
                }
                
//                NSLog(@"Leaf Object: %@ %@ %@", self.name, self.type, self.charelem);
            }
        } else {
            
        }
        self.statadd = addMut;
//        if (self.type)
//            NSLog(@"Made Stat: %@ (%@) - %@", self.name, self._value, self.type);
//        else
//            NSLog(@"Made Stat: %@ (%@)", self.name, self._value);
        
    }
    return self;
}

- (NSInteger)value
{
    return [_value intValue];
    
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
    
    __block NSString * row = @"%@: %@<br>";
    __block NSString * rowGO = @"%@: <a href=\"element://%@\">%@</a> %@<br>";
    __block NSString * rowItem = @"%@: <a href=\"item://%@\">%@</a> %@<br>";
    
#define ABILITY_HTML(key) if ([self.name isEqualToString:key]) {\
[html appendFormat:@"Base Ability Score: %@<br>",[self.character.scores.base objectForKey:NSFORMAT(@"%@",key)]]; \
}

    ABILITY_HTML(keyStrength)
    ABILITY_HTML(keyConstitution)
    ABILITY_HTML(keyDexterity)
    ABILITY_HTML(keyIntelligence)
    ABILITY_HTML(keyWisdom)
    ABILITY_HTML(keyCharisma)

    
    if ([self.name isEqualToString:@"HALF-LEVEL"]) [html appendFormat:row, @"Half-Level", PFORMAT(self._value)];
    else if ([self.type isEqualToString:@"trained"]) [html appendFormat:row,@"Trained",PFORMAT(self._value)];
    else if ([self.type isEqualToString:@"Ability"]) [html appendFormat:row,self.name,PFORMAT(self._value)];
    else if ([self.statadd count] > 0) {
        //[html appendFormat:row,self.name,@""]; // Parent
        //[html appendFormat:@"<div style=\"padding-left: 1em; \">"]; //padding-left: 2em; text-indent: -2em;
        [self.statadd enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Stat *stat = [self.character.stats objectForKey:obj];
            if (stat) [html appendString:[stat html]];
            else {
                
                // A Sub stat that has no Stat Link (values contained herin)
                NSNumber *subElem = NSINT([[obj valueForKey:@"charelem"] intValue]);
                NSString *subType = [obj valueForKey:@"type"];
                //NSString *subName = [obj valueForKey:@"name"];
                NSString *subValue = [obj valueForKey:@"value"];
                RulesElement *element = [self.character elementForCharelem:subElem];
                if (element) { // Element 1
                    if (!subType) {
                        subType = element.type;
                    }
                    [html appendFormat:rowGO,subType,element.charelem,element.name, PFORMAT(subValue)];   
                }
                
                Loot *loot = [self.character lootForCharelem:subElem];
                if (loot) { // Loot 1
                    [html appendFormat:rowItem,subType,subElem,[loot shortname], PFORMAT(subValue)];
                }
                
                if (!element && !loot) {
//                    NSLog(@"Can't Find Element1: %@", _charelem);
                    
                }
                NSArray *miscKeys = [NSArray arrayWithObjects:@"conditional",@"requires",@"not-wearing",@"wearing", nil];
                [miscKeys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
                    NSString *val = [obj valueForKey:key];                
                    if (val) {
                        [html appendFormat:@"<div style=\"padding-left: 2em; \"><i>%@</i></div>",val]; 
                    }
                }];
                
            }
        }];
        //[html appendFormat:@"</div>"];
    }
    else {
        
        if (self.charelem) {
            RulesElement *element = [self.character elementForCharelem:self.charelem];
            if (element) { // Element 2
                [html appendFormat:rowGO,element.type,element.charelem,element.name,PFORMAT(self._value)];
            }
            
            Loot *loot = [self.character lootForCharelem:self.charelem];
            if (loot) { // Loot2
                [html appendFormat:rowItem,self.name,self.charelem,[loot shortname],PFORMAT(self._value)];
            }
            
            if (!element && !loot) {
//                NSLog(@"Can't Find Element2: %@", self.charelem);
            }
            
        }
    }
    
    return html;
}

@end
