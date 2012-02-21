//
//  Character.h
//  DND4e
//
//  Created by Stephen Furlani on 2/20/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNDHTML.h"

@class Loot, AbilityScores, RulesElement;

@interface Character : NSObject <DNDHTML>

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSNumber * level;
@property (strong, nonatomic) NSMutableArray * powers;
@property (strong, nonatomic) NSMutableArray * loot;
@property (strong, nonatomic) NSMutableDictionary * details;
@property (strong, nonatomic) NSMutableArray * elements;
@property (strong, nonatomic) AbilityScores *stats;
@property (strong, nonatomic) id objectGraph;

- (NSArray*) feats;
- (NSArray*) skills;

- (id) initWithFile:(NSString*)path;
- (Loot*) lootForInternalID:(NSString*)internalID;
- (RulesElement*) elementForCharelem:(NSNumber*)charElem;

@end
