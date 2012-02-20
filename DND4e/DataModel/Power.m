//
//  Power.m
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "Power.h"
#import "Weapon.h"
#import "Data.h"

@implementation Power

@dynamic name;
@dynamic flavor;
@dynamic usage;
@dynamic display;
@dynamic keywords;
@dynamic actionType;
@dynamic attackType;
@dynamic powerType;
@dynamic target;
@dynamic attack;
@dynamic hit;
@dynamic effect;
@dynamic miss;
@dynamic level11;
@dynamic level21;
@dynamic special;
@dynamic requirement;
@dynamic primaryAttack;
@dynamic primaryTarget;
@dynamic secondaryHit;
@dynamic secondaryAttack;
@dynamic secondaryTarget;
@dynamic has_weapons;
@dynamic selected_weapon;

@end

@implementation Power (User_Methods)

- (void) populateWithDictionary:(NSDictionary *)info
{
     self.name = [info valueForKey:@"name"];
    
    NSArray *specifics = [info valueForKey:@"specific"];
    
    NSLog(@"Power: %@", self.name);
    if ([self.name isEqualToString:@"Stab and Shoot"]) {
        NSLog(@"Info: %@", info);
    }
    [specifics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *name = [obj valueForKey:@"name"];
        NSString *value = [obj valueForKey:@"value"];
//        NSLog(@"%@: %@", name, value);
        
        if ([name isEqualToString:@"Flavor"]) self.flavor = value;
        else if ([name isEqualToString:@"Power Usage"]) self.usage = value;
        else if ([name isEqualToString:@"Display"]) self.display = value;
        else if ([name isEqualToString:@"Keywords"]) self.keywords = value;
        else if ([name isEqualToString:@"Action Type"]) self.actionType = value;
        else if ([name isEqualToString:@"Attack Type"]) self.attackType = value;
        else if ([name isEqualToString:@"Target"]) self.target = value;
        else if ([name isEqualToString:@"Attack"]) self.attack = value;
        else if ([name isEqualToString:@"Hit"]) self.hit = value;
        else if ([name isEqualToString:@" Level 21"]) self.level21 = value;
        else if ([name isEqualToString:@"Miss"]) self.miss = value;
        else if ([name isEqualToString:@"Power Type"]) self.powerType = value;
        else if ([name isEqualToString:@"Effect"]) self.effect = value;
        else if ([name isEqualToString:@"Special"]) self.special = value;
        else if ([name isEqualToString:@"Requirement"]) self.requirement = value;
        else if ([name isEqualToString:@"Primary Target"]) self.primaryTarget = value;
        else if ([name isEqualToString:@"Primary Attack"]) self.primaryAttack = value;
        else if ([name isEqualToString:@" Secondary Target"]) self.secondaryTarget = value;
        else if ([name isEqualToString:@" Secondary Attack"]) self.secondaryAttack = value;
        else if ([name isEqualToString:@" Hit"]) self.secondaryHit = value;
        
    }];
    
    id weapons = [info valueForKey:@"Weapon"];
    if ([weapons isKindOfClass:[NSArray class]]) {
        [weapons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Weapon *weapon = [AppData newWeapon];
            [weapon populateWithDictionary:obj];
            [self addHas_weaponsObject:weapon];
            if (!self.selected_weapon) {
                self.selected_weapon = weapon;
            }
        }];
    }
}

@end
