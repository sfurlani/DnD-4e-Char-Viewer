//
//  Skill.m
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "Skill.h"
#import "Data.h"

@implementation Skill

@synthesize name = _name;
@synthesize character;
@synthesize components;

- (id) initWithName:(NSString*)name
{
    self = [super init];
    if (self) {
        self.name = name;
        self.components = [NSMutableArray array];
    }
    return self;
}

- (void) populateFromElements:(NSArray*)elements
{
    
    
    
}


- (NSString*) html
{
    return @"Nothing Yet";
}

@end
