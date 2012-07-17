//
//  Character.h
//  DND4e
//
//  Created by Stephen Furlani on 2/20/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
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
@property (strong, nonatomic) NSMutableArray * traits;

- (NSArray*) feats;

- (id) initWithFile:(NSString*)path;
- (Loot*) lootForInternalID:(NSString*)internalID;
- (Loot*) lootForCharelem:(NSNumber*)charElem;
- (RulesElement*) elementForInternalID:(NSString*)internalID;
- (RulesElement*) elementForCharelem:(NSNumber*)charElem;
- (NSArray*) elementsForKey:(NSString*)key matchingValue:(NSString*)value exact:(BOOL)exact;

@end
