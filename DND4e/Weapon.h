//
//  Weapon.h
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RulesElement.h"

@class Power;

@interface Weapon : RulesElement

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * attackBonus;
@property (nonatomic, retain) NSString * defense;
@property (nonatomic, retain) NSString * damage;
@property (nonatomic, retain) NSString * attackStat;
@property (nonatomic, retain) NSString * hitComponents;
@property (nonatomic, retain) NSString * damageComponents;
@property (nonatomic, retain) NSString * conditions;
@property (nonatomic, retain) Power *in_power;

@end

@interface  Weapon (User_Methods)

- (void) populateWithDictionary:(NSDictionary *)info;

@end
