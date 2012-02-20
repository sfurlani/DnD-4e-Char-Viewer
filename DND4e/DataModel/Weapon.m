//
//  Weapon.m
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "Weapon.h"
#import "Power.h"
#import "RulesElement.h"
#import "Data.h"

@implementation Weapon

@dynamic name;
@dynamic attackBonus;
@dynamic defense;
@dynamic damage;
@dynamic attackStat;
@dynamic hitComponents;
@dynamic damageComponents;
@dynamic conditions;
@dynamic critRange;
@dynamic critComponents;
@dynamic critDamage;
@dynamic in_power;
@dynamic has_elements;

@end

@implementation Weapon (User_Methods)

- (void) populateWithDictionary:(NSDictionary *)info
{
    self.name = [info objectForKey:@"name"];
    NSLog(@"Weapon: %@", self.name);
//    if ([self.name isEqualToString:@"Supreme Skirmisher's Bow Greatbow +2"]) {
        NSLog(@"Info: %@", info);
//    }
    
    [info enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *value = obj;
        if ([obj isKindOfClass:[NSDictionary class]])
            value = [obj valueForKey:@"value"];
//        NSLog(@"%@: %@", key, value);
        
        if ([key isEqualToString:@"name"]) {} // handled above
        else if ([key isEqualToString:@"DamageComponents"]) self.damageComponents = value;
        else if ([key isEqualToString:@"AttackBonus"]) self.attackBonus = value;
        else if ([key isEqualToString:@"Defense"]) self.defense = value;
        else if ([key isEqualToString:@"HitComponents"]) self.hitComponents = value;
        else if ([key isEqualToString:@"Damage"]) self.damage = value;
        else if ([key isEqualToString:@"AttackStat"]) self.attackStat = value;
        else if ([key isEqualToString:@"Conditions"]) self.conditions = value;
        else if ([key isEqualToString:@"CridRange"]) self.critRange = value;
        else if ([key isEqualToString:@"CridDamage"]) self.critDamage = value;
        else if ([key isEqualToString:@"CridComponents"]) self.critComponents = value;
        else if ([key isEqualToString:@"RulesElement"]) { 
            if ([obj isKindOfClass:[NSDictionary class]]) {
                RulesElement *elem = [AppData newElement];
                [elem populateWithDictionary:obj];
                [self addHas_elementsObject:elem];
            } else if ([obj isKindOfClass:[NSArray class]]) {
                [obj enumerateObjectsUsingBlock:^(id ele, NSUInteger idx, BOOL *stop) {
                    RulesElement *elem = [AppData newElement];
                    [elem populateWithDictionary:ele];
                    [self addHas_elementsObject:elem];
                }];
            }
        }
        
    }];
    
}

@end

