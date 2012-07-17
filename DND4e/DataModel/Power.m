//
//  Power.m
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

#import "Power.h"
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
@synthesize character;

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
    
    if (NO && [self.name isEqualToString:@"Dispel Magic"]) {
        NSLog(@"Power: %@", self.name);
        NSLog(@"Info: %@", info);
    }
    
    [specs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [obj valueForKey:@"name"];
        NSString *value = [obj valueForKey:kXMLReaderTextNodeKey];
        
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
    
    // HEADER
    if (self.flavor)
        [html appendFormat:@"<div style=\"background-color:rgba(44,44,44,0.12)\"><p><i>%@</i><p></div>",self.flavor];
    
    [html appendFormat:@"<p>%@ * %@</p>", self.usage, self.actionType];
    
    [html appendString:@"<p>"];
    __block NSString *withHeader = @"<b>%@</b> %@<br>";
    __block NSString *withColon = @"<b>%@:</b> %@<br>";
    __block NSString *withColonGray = @"<div style=\"background-color:rgba(44,44,44,0.12)\"><b>%@:</b> %@</div>";
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
    
    [html appendString:@"</p><p>"];
    
    // SPECIFICS
    [self.specifics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [obj valueForKey:@"name"];
        NSString *value = [obj valueForKey:kXMLReaderTextNodeKey];
        NSString *colon = (idx%2 == 1 ? withColon : withColonGray);
        if ([self shouldDisplaySpecific:key])
            [html appendFormat:colon, key, replace(value)];
        
    }];
    
    [html appendString:@"</p><p>"];
    
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
        
        [html appendFormat:@"<a href=\"weapon://\"><b>%@</b></a> %@<br>",wpn_name,text];
        [html appendString:@"<a href=\"change://\"> - Change Weapon - </a><br><br>"];
        
        // CONDITIONALS 
        if (self.selected_weapon.conditions)
        [html appendFormat:withHeader,@"Additional Effects: <br>",replace(self.selected_weapon.conditions)];
        
        [html appendFormat:@"<p></p>"];
        
        // HIT COMPONENTS
        [html appendFormat:withHeader,@"Breakdown of Attack: <br>",replace(self.selected_weapon.hitComponents)];
        
        // DAMAGE COMPONENTS
        [html appendFormat:withHeader,@"Breakdown of Damage: <br>",replace(self.selected_weapon.damageComponents)];
        
        // COMPENDIUM ENTRIES
        [html appendString:@"</p><p>"];
        [self.selected_weapon.has_elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            RulesElement *element = obj;
            NSString *title = element.name;
            NSString *url = element.url_string;
            
            [html appendFormat:@"<a href=\"%@\"> Compendium Entry: %@ </a></p>",url, title];
            
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
