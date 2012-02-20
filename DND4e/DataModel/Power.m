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

@synthesize name;
@synthesize flavor;
@synthesize usage;
@synthesize display;
@synthesize keywords;
@synthesize actionType;
@synthesize attackType;
@synthesize powerType;
@synthesize specifics;
@synthesize has_weapons;
@synthesize selected_weapon;

- (id) init
{
    self = [super init];
    if (self) {
        self.has_weapons = [NSMutableArray array];
        self.specifics = [NSMutableArray array];
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
     self.name = [info valueForKey:@"name"];
    
    NSArray *specs = [info valueForKey:@"specific"];
    
    NSLog(@"Power: %@", self.name);
    [specs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [obj valueForKey:@"name"];
        NSString *value = [obj valueForKey:@"value"];
        
        if ([key isEqualToString:@"Flavor"]) self.flavor = value;
        else if ([key isEqualToString:@"Power Usage"]) self.usage = value;
        else if ([key isEqualToString:@"Display"]) self.display = value;
        else if ([key isEqualToString:@"Keywords"]) self.keywords = value;
        else if ([key isEqualToString:@"Action Type"]) self.actionType = value;
        else if ([key isEqualToString:@"Attack Type"]) self.attackType = value;
        else {
            [self.specifics addObject:obj];
        }
        
    }];
    
    id weapons = [info valueForKey:@"Weapon"];
    if ([weapons isKindOfClass:[NSArray class]]) {
        [weapons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Weapon *weapon = [[Weapon alloc] initWithDictionary:obj];
            [self.has_weapons addObject:weapon];
            if (!self.selected_weapon) {
                self.selected_weapon = weapon;
            }
        }];
    }
}

@end
