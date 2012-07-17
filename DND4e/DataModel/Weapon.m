//
//  Weapon.m
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
//

#import "Weapon.h"
#import "Power.h"
#import "RulesElement.h"
#import "Data.h"
#import "Utility.h"

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
            value = [obj valueForKey:kXMLReaderTextNodeKey];
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

