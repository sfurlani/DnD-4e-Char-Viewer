//
//  Stat.h
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNDHTML.h"

@class Character;

@interface Stat : NSObject <DNDHTML>

@property (strong, nonatomic) NSString * name;
@property (assign, nonatomic) NSInteger level;
@property (strong, nonatomic) NSNumber * charelem;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSArray * statadd;
@property (unsafe_unretained, nonatomic) Character *character;
@property (strong, nonatomic) NSDictionary * info;

- (id) initWithDictionary:(NSDictionary*)info;

- (NSInteger) value;

@end
