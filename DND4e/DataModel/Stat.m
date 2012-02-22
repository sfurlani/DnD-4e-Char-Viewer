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
@synthesize info = _info;

- (id) initWithDictionary:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.info = info;
        
        // Alias
        if ([[info valueForKey:@"alias"] isKindOfClass:[NSDictionary class]])
            self.name = [info valueForKeyPath:@"alias.name"];
        else 
            self.name = [[[info valueForKey:@"alias"] objectAtIndex:0] valueForKey:@"name"];
        
//        NSLog(@"Making Stat: %@", self.name);
        
        self.level = [[info valueForKey:@"level"] intValue];
        self.charelem = NSINT([[info valueForKey:@"charelem"] intValue]);
        
        // Stat Add
        id addInfo = [info valueForKey:@"statadd"];
        if ([self.name rangeOfString:@"Misc"].length > 0) NSLog(@"%@: %@",self.name, addInfo);
        NSMutableArray *addMut = [NSMutableArray arrayWithCapacity:[addInfo count]];
        if (addInfo) {
            if (![addInfo isKindOfClass:[NSDictionary class]]) {
                [addInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSString *link = [obj valueForKeyPath:@"statlink"];
                    if (link) {
                        [addMut addObject:link];
                    } else
                        [addMut addObject:obj];
                }];
            } else {
                NSString *alias = [addInfo valueForKeyPath:@"statlink"];
                if (alias)
                    [addMut addObject:alias];
            }
        }
        self.statadd = addMut;
        
        
    }
    return self;
}

- (NSInteger)value
{
    __block NSInteger value = 0;
    
    if ([self.name isEqualToString:@"HALF-LEVEL"]) value += [self.statadd count];
    else if ([self.type isEqualToString:@"Ability"]) NSLog(@"Go Get: %@", self.name);
    else if ([self.name rangeOfString:@"Trained"].length > 0) value += 5;
    else if ([self.name rangeOfString:@"Misc"].length > 0) {
//        NSLog(@"Stat Info: %@", self.info);
        
    } else {
        [self.statadd enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                Stat *stat = [self.character.stats objectForKey:obj];
                value += [stat value];
            } else {
               // TODO: what?
            }
        }];
    }

    return value;
}

- (NSString*)html
{
    __block NSMutableString *html = [NSMutableString string];
    
    __block NSString * row = @"<b>%@: </b>%@<br>";
    
    if ([self.name isEqualToString:@"HALF-LEVEL"]) [html appendFormat:row,@"Half-Level",NSFORMAT(@"+%d",[self.statadd count])];
    else if ([self.type isEqualToString:@"Ability"]) [html appendFormat:row,self.name,@" - need to calculate - "];
    else if ([self.name rangeOfString:@"Trained"].length > 0) [html appendFormat:row, self.name, @"+5"];
//    else if ([self.name rangeOfString:@"Misc"].length > 0) {
////        NSLog(@"Stat Info: %@", self.info);
//        Stat *stat = [self.character.stats objectForKey:self.name];
//        [html appendFormat:row, @"Info", stat.statadd];
//        
//    } 
    else {
        [self.statadd enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                Stat *stat = [self.character.stats objectForKey:obj];
                [html appendString:[stat html]];
            } else {
                // TODO: fix this
//                value += 1;
//                if ([[obj valueForKey:@"Level"] intValue] == 1) value += 1;
            }
        }];
    }
    //    NSLog(@"Stat: %@ (%d)", self.name, value);
    return html;
}

@end
