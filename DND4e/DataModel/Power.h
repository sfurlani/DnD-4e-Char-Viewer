//
//  Power.h
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DNDObject.h"

@class Weapon;

@interface Power : DNDObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * flavor;
@property (nonatomic, retain) NSString * usage;
@property (nonatomic, retain) NSString * display;
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSString * actionType;
@property (nonatomic, retain) NSString * attackType;
@property (nonatomic, retain) NSString * powerType;
@property (nonatomic, retain) NSString * target;
@property (nonatomic, retain) NSString * attack;
@property (nonatomic, retain) NSString * hit;
@property (nonatomic, retain) NSString * effect;
@property (nonatomic, retain) NSString * miss;
@property (nonatomic, retain) NSString * level11;
@property (nonatomic, retain) NSString * level21;
@property (nonatomic, retain) NSString * special;
@property (nonatomic, retain) NSString * requirement;
@property (nonatomic, retain) NSString * primaryTarget;
@property (nonatomic, retain) NSString * primaryAttack;
@property (nonatomic, retain) NSString * secondaryTarget;
@property (nonatomic, retain) NSString * secondaryAttack;
@property (nonatomic, retain) NSString * secondaryHit;
@property (nonatomic, retain) NSSet *has_weapons;
@property (nonatomic, retain) Weapon *selected_weapon;
@end

@interface Power (CoreDataGeneratedAccessors)

- (void)addHas_weaponsObject:(Weapon *)value;
- (void)removeHas_weaponsObject:(Weapon *)value;
- (void)addHas_weapons:(NSSet *)values;
- (void)removeHas_weapons:(NSSet *)values;
@end


@interface Power (User_Methods)

- (void) populateWithDictionary:(NSDictionary*)info;

@end