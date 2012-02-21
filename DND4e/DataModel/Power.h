//
//  Power.h
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "DNDHTML.h"

@class Weapon, Character;

@interface Power : NSObject <DNDHTML>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * flavor;
@property (nonatomic, strong) NSString * usage;
@property (nonatomic, strong) NSString * display;
@property (nonatomic, strong) NSString * keywords;
@property (nonatomic, strong) NSString * actionType;
@property (nonatomic, strong) NSString * attackType;
@property (nonatomic, strong) NSString * powerType;
@property (nonatomic, strong) NSMutableArray * specifics;
@property (nonatomic, strong) NSMutableArray * has_weapons;
@property (nonatomic, strong) Weapon *selected_weapon;
@property (nonatomic, unsafe_unretained) Character* character;

- (id) initWithDictionary:(NSDictionary*)info;
- (void) populateWithDictionary:(NSDictionary*)info;

- (BOOL) shouldDisplaySpecific:(NSString*)key;
@end