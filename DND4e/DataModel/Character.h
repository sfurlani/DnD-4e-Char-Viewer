//
//  Character.h
//  DND4e
//
//  Created by Stephen Furlani on 2/20/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNDHTML.h"

@interface Character : NSObject <DNDHTML>

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSMutableArray * powers;
@property (strong, nonatomic) NSMutableArray * loot;

- (id) initWithFile:(NSString*)path;

@end
