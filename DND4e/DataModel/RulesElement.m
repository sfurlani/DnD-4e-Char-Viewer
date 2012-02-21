//
//  RulesElement.m
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "RulesElement.h"
#import "Utility.h"

@implementation RulesElement

@synthesize charelem;
@synthesize type;
@synthesize name;
@synthesize internal_id;
@synthesize legal;
@synthesize url_string;
@synthesize specifics;

- (id) init
{
    self = [super init];
    if (self) {
        self.specifics = [NSMutableArray array];
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary*)info
{
    self = [self init];
    if (self) {
        [self populateWithDictionary:info];
    }
    return self;
}

- (void) populateWithDictionary:(NSDictionary *)info
{
    self.url_string = [info valueForKey:@"url"];
    self.name = [info valueForKey:@"name"];
    self.charelem = NSINT([[info valueForKey:@"charelem"] intValue]);
    self.legal = NSBOOL([[info valueForKey:@"legality"] isEqualToString:@"rules-legal"]);
    self.internal_id = [info valueForKey:@"internal-id"];
    self.type = [info valueForKey:@"type"];
    id specInfo = [info valueForKey:@"specific"];
    if ([specInfo isKindOfClass:[NSArray class]]) {
        [specInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.specifics addObject:obj];
        }];
    } else {
        [self.specifics addObject:specInfo];
    }
}

@end
