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
@synthesize description;

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
    if (specInfo)
    if ([specInfo isKindOfClass:[NSArray class]]) {
        [specInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.specifics addObject:obj];
        }];
    } else {
        [self.specifics addObject:specInfo];
    }
    NSString *value = [info valueForKey:@"value"];
    if ([value length] > 2) {
        self.description = value;
    }
}

- (NSString*) html
{
    __block NSMutableString *html = [NSMutableString string];
    
    [html appendFormat:@"<h3>%@</h3>",self.name];
    [html appendString:@"<dl>"];
    __block NSString *row = @"<dt><b>%@:</b> %@</dt>";
    [html appendFormat:row,@"Type",self.type];
    //[html appendFormat:row,@"Element",self.charelem];
    if(![self.legal boolValue]) [html appendFormat:row,@"House Ruled",@"yes"];
    if ([self.specifics count] > 0) {
        [self.specifics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *key = [obj valueForKey:@"name"];
            NSString *value = [obj valueForKey:@"value"];
            if ([self shouldDisplaySpecific:key])
                [html appendFormat:row,key,value];
            else if ([key isEqualToString:@"Granted Powers"]) {
                // TODO: add Power
                
            }
        }];
    }
    if (self.description)
        [html appendFormat:row,@"Description",self.description];
    
    [html appendString:@"</dl>"];
    
    NSString *title = self.name;
    NSString *url = self.url_string;
    if (url)
        [html appendFormat:@"<p><a href=\"%@\"> Compendium Entry: %@ </a></p>",url, title];
    
    return html;
}

- (BOOL) shouldDisplaySpecific:(NSString*)key
{
    // Don't display rules elements
    if ([key hasPrefix:@"_"]) return NO;
    if ([key hasPrefix:@"Granted Powers"]) return NO;
    
    return YES;
}


@end
