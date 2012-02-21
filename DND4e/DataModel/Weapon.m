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

@synthesize name;
@synthesize attackBonus;
@synthesize defense;
@synthesize damage;
@synthesize attackStat;
@synthesize hitComponents;
@synthesize damageComponents;
@synthesize conditions;
@synthesize critRange;
@synthesize critComponents;
@synthesize critDamage;
@synthesize in_power;
@synthesize has_elements;

- (id) init
{
    self = [super init];
    if (self) {
        self.has_elements = [NSMutableArray array];
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

- (void) populateWithDictionary:(NSDictionary *)info
{
    self.name = [info objectForKey:@"name"];
    if (NO  && [self.name isEqualToString:@""]) {
        NSLog(@"Weapon: %@", self.name);
        NSLog(@"Info: %@", info);
    }
    
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
                RulesElement *elem = [[RulesElement alloc] initWithDictionary:obj];
                [self.has_elements addObject:elem];
            } else if ([obj isKindOfClass:[NSArray class]]) {
                [obj enumerateObjectsUsingBlock:^(id ele, NSUInteger idx, BOOL *stop) {
                    RulesElement *elem = [[RulesElement alloc] initWithDictionary:ele];
                    [self.has_elements addObject:elem];
                }];
            }
        }
        
    }];
    
}

@end

