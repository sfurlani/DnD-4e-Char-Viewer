//
//  Stat.m
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "Stat.h"
#import "Data.h"
#import "Utility.h"

@implementation Stat

@synthesize name, level, charelem, type, statadd, character;

- (id) initWithDictionary:(NSDictionary*)info
{
    self = [super init];
    if (self) {

        // Alias
        if ([[info valueForKey:@"alias"] isKindOfClass:[NSDictionary class]])
            self.name = [info valueForKeyPath:@"alias.name"];
        else 
            self.name = [[[info valueForKey:@"alias"] objectAtIndex:0] valueForKey:@"name"];
        
        self.level = [[info valueForKey:@"level"] intValue];
        self.charelem = NSINT([[info valueForKey:@"charelem"] intValue]);
        
        // Stat Add
        id addInfo = [info valueForKey:@"statadd"];
        NSMutableArray *addMut = [NSMutableArray arrayWithCapacity:[addInfo count]];
        
        if (![addInfo isKindOfClass:[NSDictionary class]]) {
            [addInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *alias = [obj valueForKeyPath:@"alias.name"];
                if (alias)
                    [addMut addObject:alias];
            }];
        } else {
            NSString *alias = [addInfo valueForKeyPath:@"alias.name"];
            if (alias)
                [addMut addObject:alias];
        }
        self.statadd = addMut;
        
    }
    return self;
}

- (NSInteger)value
{
    __block NSInteger value = 0;
    
    [self.statadd enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Stat *stat = [self.character.stats objectForKey:obj];
        value += stat.value;
    }];
    
    return value;
}

- (NSString*)html
{
    return @"";
}

@end
