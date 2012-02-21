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
#import "Utility.h"

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
    
    if ([self.name isEqualToString:@"Dispel Magic"]) {
        NSLog(@"Power: %@", self.name);
        NSLog(@"Info: %@", info);
    }
    
    
    [specs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [obj valueForKey:@"name"];
        NSString *value = [obj valueForKey:@"value"];
        
        if ([key isEqualToString:@"Flavor"]) self.flavor = value;
        else if ([key isEqualToString:@"Power Usage"]) self.usage = value;
        else if ([key isEqualToString:@"Display"]) self.display = value;
        else if ([key isEqualToString:@"Keywords"]) self.keywords = value;
        else if ([key isEqualToString:@"Action Type"]) self.actionType = value;
        else if ([key isEqualToString:@"Attack Type"]) self.attackType = value;
        else if ([key isEqualToString:@"Power Type"]) self.powerType = value;
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

- (NSString*)html
{
    __block NSMutableString *html = [NSMutableString string];
    #define replace(string) ([string stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"])
    
    // HEADER
    if (self.flavor)
        [html appendFormat:@"<p><i>%@</i><p>",self.flavor];
    
    [html appendFormat:@"<p>%@ * %@</p>", self.usage, self.actionType];
    
    __block NSString *withHeader = @"<p><b>%@</b> %@</p>";
    __block NSString *withColon = @"<p><b>%@:</b> %@</p>";
    if (self.keywords)
        [html appendFormat:withHeader,@"Keywords:",self.keywords];
    
    if (self.attackType) {
        NSMutableArray *words = [[self.attackType componentsSeparatedByString:@" "] mutableCopy];
        if ([words count] > 1) {
            NSString *first = NSFORMAT(@"%@ ", [words objectAtIndex:0]);
            [words removeObjectAtIndex:0];
            NSString *rest = [words componentsJoinedByString:@" "];
            [html appendFormat:withHeader,first,rest];
        } else {
            [html appendFormat:withHeader,self.attackType,@""];
        }
    }
    
    // SPECIFICS
    [self.specifics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [obj valueForKey:@"name"];
        NSString *value = [obj valueForKey:@"value"];
        if ([self shouldDisplaySpecific:key])
            [html appendFormat:withColon, key, replace(value)];
        
    }];
    
    
    // WEAPON
    if (self.selected_weapon) {
        NSString *wpn_name = NSFORMAT(@"%@: ", self.selected_weapon.name);
        NSString *bonus = ([self.selected_weapon.attackBonus intValue] > 0 ? 
                           NSFORMAT(@"+%@", self.selected_weapon.attackBonus) : 
                           self.selected_weapon.attackBonus);
        
        NSString *text = NSFORMAT(@"%@ vs. %@, %@ damage", 
                                  bonus,
                                  self.selected_weapon.defense,
                                  self.selected_weapon.damage);
        if (!self.selected_weapon.defense)
            text = NSFORMAT(@"%@ damage", self.selected_weapon.damage);
        
        [html appendFormat:@"<p><b>%@</b> %@ <br> <a href=\"weapon://\"> - Change Weapon - </a></p>",wpn_name,text];
        
        // CONDITIONALS 
        if (self.selected_weapon.conditions)
        [html appendFormat:withHeader,@"Additional Effects: <br>",replace(self.selected_weapon.conditions)];
        
        [html appendFormat:@"<p></p>"];
        
        // HIT COMPONENTS
        [html appendFormat:withHeader,@"Breakdown of Attack: <br>",replace(self.selected_weapon.hitComponents)];
        
        // DAMAGE COMPONENTS
        [html appendFormat:withHeader,@"Breakdown of Damage: <br>",replace(self.selected_weapon.damageComponents)];
        
        [self.selected_weapon.has_elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RulesElement *element = obj;
            NSString *title = element.name;
            NSString *url = element.url_string;
            
            [html appendFormat:@"<p><a href=\"%@\"> Compendium Entry: %@ </a></p>",url, title];
            
        }];
        
        
        
    }
    
    
    return html;
}


- (BOOL) shouldDisplaySpecific:(NSString*)key
{
    // Don't display rules elements
    if ([key hasPrefix:@"_"]) return NO;
    if ([key hasPrefix:@"Class"]) return NO;
    if ([key hasPrefix:@"Level"]) return NO;
    
    return YES;
}

@end
