//
//  Loot.h
//  DND4e
//
//  Created by Stephen Furlani on 2/20/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNDHTML.h"

@class RulesElement, Character;

@interface Loot : NSObject <DNDHTML>

@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) RulesElement *element;
@property (nonatomic, unsafe_unretained) Character* character;

- (id) initWithDictionary:(NSDictionary*)info;
- (void) populateWithDictionary:(NSDictionary*)info;

- (NSString*) shortname;

@end


@interface Item : NSObject <DNDHTML>

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * flavor;
@property (nonatomic, strong) NSString * fullText;
@property (nonatomic, strong) NSMutableArray * specifics;
@property (nonatomic, strong) RulesElement * element;

- (id) initWithDictionary:(NSDictionary*)info;
- (void) populateWithDictionary:(NSDictionary*)info;

- (BOOL) shouldDisplaySpecific:(NSString*)key;

@end