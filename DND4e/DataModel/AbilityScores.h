//
//  AbilityScores.h
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNDHTML.h"

@class Character, RulesElement;

@interface AbilityScores : NSObject <DNDHTML>

@property (unsafe_unretained, nonatomic) Character *character;
@property (strong, nonatomic) NSMutableDictionary * stats;
@property (strong, nonatomic) NSMutableDictionary * scores;

- (id) initWithDictionary:(NSDictionary*)info;
- (void) populateWithDictionary:(NSDictionary*)info;

@end

@interface Score : NSObject <DNDHTML>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *aliases;
@property (strong, nonatomic) NSNumber *level;
@property (unsafe_unretained, nonatomic) AbilityScores *parent;
@property (strong, nonatomic) NSMutableArray * components;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * statlink;

- (id) initWithName:(NSString*)name;

@end
