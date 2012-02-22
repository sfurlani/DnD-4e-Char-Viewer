//
//  AbilityScores.h
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNDHTML.h"

extern NSString * const keyStrength;
extern NSString * const keyConstitution;
extern NSString * const keyDexterity;
extern NSString * const keyIntelligence;
extern NSString * const keyWisdom;
extern NSString * const keyCharisma;

@class Character, RulesElement;

@interface AbilityScores : NSObject <DNDHTML>

@property (unsafe_unretained, nonatomic) Character *character;
@property (strong, nonatomic) NSMutableDictionary * base;
@property (strong, nonatomic) NSMutableDictionary * stats;

- (id) initWithDictionary:(NSDictionary*)info;
- (void) populateWithDictionary:(NSDictionary*)info;

- (NSNumber*)score:(NSString*)ability;
- (NSNumber*)modifier:(NSString*)ability;

@end