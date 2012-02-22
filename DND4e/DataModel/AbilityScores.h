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
@property (strong, nonatomic) NSMutableDictionary * base;
@property (strong, nonatomic) NSMutableDictionary * stats;

- (id) initWithDictionary:(NSDictionary*)info;
- (void) populateWithDictionary:(NSDictionary*)info;

- (NSNumber*)score:(NSString*)ability;
- (NSNumber*)modifier:(NSString*)ability;

@end