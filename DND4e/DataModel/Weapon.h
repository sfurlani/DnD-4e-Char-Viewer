//
//  Weapon.h
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Power, RulesElement;

@interface Weapon : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * attackBonus;
@property (nonatomic, strong) NSString * defense;
@property (nonatomic, strong) NSString * damage;
@property (nonatomic, strong) NSString * attackStat;
@property (nonatomic, strong) NSString * hitComponents;
@property (nonatomic, strong) NSString * damageComponents;
@property (nonatomic, strong) NSString * conditions;
@property (nonatomic, strong) NSString * critRange;
@property (nonatomic, strong) NSString * critDamage;
@property (nonatomic, strong) NSString * critComponents;
@property (nonatomic, strong) Power *in_power;
@property (nonatomic, strong) NSMutableArray *has_elements;

- (id) initWithDictionary:(NSDictionary*)info;
- (void) populateWithDictionary:(NSDictionary *)info;

@end
