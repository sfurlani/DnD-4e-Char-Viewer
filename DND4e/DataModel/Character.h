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
@property (strong, nonatomic) NSMutableDictionary *stats;
@property (strong, nonatomic) AbilityScores *scores;
@property (strong, nonatomic) id objectGraph;
@property (strong, nonatomic) NSMutableArray * skills;
@property (strong, nonatomic) NSArray * feats;
@property (strong, nonatomic) NSArray * features;
@property (strong, nonatomic) NSArray * traits;

- (NSArray*) feats;

- (id) initWithFile:(NSString*)path;
- (Loot*) lootForInternalID:(NSString*)internalID;
- (Loot*) lootForCharelem:(NSNumber*)charElem;
- (RulesElement*) elementForInternalID:(NSString*)internalID;
- (RulesElement*) elementForCharelem:(NSNumber*)charElem;

@end
