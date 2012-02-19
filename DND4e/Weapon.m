//
//  Weapon.m
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "Weapon.h"
#import "Power.h"


@implementation Weapon

@dynamic name;
@dynamic attackBonus;
@dynamic defense;
@dynamic damage;
@dynamic attackStat;
@dynamic hitComponents;
@dynamic damageComponents;
@dynamic in_power;

@end

@implementation Weapon (User_Methods)

- (void) populateWithDictionary:(NSDictionary *)info
{
    [info enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *value = obj;
        if ([obj isKindOfClass:[NSDictionary class]])
            value = [obj valueForKey:@"value"];
        
        if ([key isEqualToString:@"name"]) self.name = value;
        else if ([key isEqualToString:@"DamageComponents"]) self.damageComponents = value;
        else if ([key isEqualToString:@"AttackBonus"]) self.attackBonus = value;
        else if ([key isEqualToString:@"Defense"]) self.defense = value;
        else if ([key isEqualToString:@"HitComponents"]) self.hitComponents = value;
        else if ([key isEqualToString:@"Damage"]) self.damage = value;
        else if ([key isEqualToString:@"AttackStat"]) self.attackStat = value;
        else if ([key isEqualToString:@"RulesElement"]) { /* [super populateWithDictionary:obj] */ }
        
    }];
    
}

@end

