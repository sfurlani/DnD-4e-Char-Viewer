//
//  Skill.h
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNDHTML.h"

@class Character, RulesElement;

@interface Skill : NSObject <DNDHTML>

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSArray * components;
@property (strong, nonatomic) NSNumber * bonus;
@property (unsafe_unretained, nonatomic) Character* character;
@property (strong, nonatomic) RulesElement * element;

- (id) initWithName:(NSString*)name;
- (void) populateFromCharacter:(Character*)character;

@end
