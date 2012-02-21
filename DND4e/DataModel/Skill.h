//
//  Skill.h
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNDHTML.h"

@class Character;

@interface Skill : NSObject <DNDHTML>

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSMutableArray * components;
@property (unsafe_unretained, nonatomic) Character* character;

- (id) initWithName:(NSString*)name;
- (void) populateFromElements:(NSArray*)elements;

@end
