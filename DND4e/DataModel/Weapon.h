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

@interface Weapon : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * attackBonus;
@property (nonatomic, retain) NSString * defense;
@property (nonatomic, retain) NSString * damage;
@property (nonatomic, retain) NSString * attackStat;
@property (nonatomic, retain) NSString * hitComponents;
@property (nonatomic, retain) NSString * damageComponents;
@property (nonatomic, retain) NSString * conditions;
@property (nonatomic, retain) NSString * critRange;
@property (nonatomic, retain) NSString * critDamage;
@property (nonatomic, retain) NSString * critComponents;
@property (nonatomic, retain) Power *in_power;
@property (nonatomic, retain) NSSet *has_elements;

@end

@interface Weapon (CoreDataGeneratedAccessors)

- (void)addHas_elementsObject:(RulesElement *)value;
- (void)removeHas_elementsObject:(RulesElement *)value;
- (void)addHas_elements:(NSSet *)values;
- (void)removeHas_elements:(NSSet *)values;
@end


@interface  Weapon (User_Methods)

- (void) populateWithDictionary:(NSDictionary *)info;

@end
