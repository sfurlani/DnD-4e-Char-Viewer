//
//  Loot.m
//  DND4e
//
//  Created by Stephen Furlani on 2/20/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "Loot.h"
#import "Data.h"

#define replace(string) ([[string stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"] stringByReplacingOccurrencesOfString:@"\t" withString:@"&nbsp;&nbsp;&nbsp;&nbsp;"])

@implementation Loot

@synthesize items, element;
@synthesize character;

- (id) init
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)info
{
    self = [self init];
    if (self) {
        [self populateWithDictionary:info];
    }
    return self;
}

- (void) populateWithDictionary:(NSDictionary *)info
{
    id elements = [info valueForKey:@"RulesElement"];
    if ([elements isKindOfClass:[NSArray class]]) {
        [elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Item *item = [[Item alloc] initWithDictionary:obj];
            [self.items addObject:item];
        }];
        
    } else {
        Item *item = [[Item alloc] initWithDictionary:elements];
        [self.items addObject:item];
    }
    
    self.element = [[RulesElement alloc] initWithDictionary:info];
}

- (NSString*)html
{
    NSMutableString *html = [NSMutableString string];
    
    
    if ([self.items count] == 1) {
        Item *only = [self.items lastObject];
        [html appendString:[only html]];
        if (only.fullText)
            [html appendString:only.fullText];
    } else if ([self.items count] == 2) {
        Item *magic = [self.items lastObject];
        Item *mundane = [self.items objectAtIndex:0];
        [html appendString:[magic html]];
        [html appendString:@"<hr width=\"260\">"];
        if (mundane.fullText) {
            [html appendString:mundane.fullText];
        } else {
            [html appendString:[mundane html]];
        }
        
    } else {
        [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx < [self.items count]-1) {
                [html appendFormat:@"%@<hr width=\"260\">",[obj html]];
            } else {
                [html appendString:[obj html]];
            }
        }];

    }
    
    return html;
}

- (NSString*) name
{
    NSMutableString *name = [NSMutableString string];
    
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [name appendFormat:@"%@ ",[obj name]];
    }];
    
    return name;
}

@end

@implementation Item

@synthesize name, flavor, fullText;
@synthesize element;
@synthesize specifics;

- (id) init
{
    self = [super init];
    if (self) {
        self.specifics = [NSMutableArray array];
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)info
{
    self = [self init];
    if (self) {
        [self populateWithDictionary:info];
    }
    return self;
}

- (void) populateWithDictionary:(NSDictionary *)info
{
    self.name = [info valueForKey:@"name"];
    self.element = [[RulesElement alloc] initWithDictionary:info];
    
    id specs = [info valueForKey:@"specific"];
    [specs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [obj valueForKey:@"name"];
        NSString *value = [obj valueForKey:@"value"];
        
        if ([key isEqualToString:@"Flavor"]) self.flavor = value;
        else if ([key isEqualToString:@"Full Text"]) self.fullText = replace(value);
        else {
            [self.specifics addObject:obj];
        }
    }];
    
}

- (NSString*)html
{
    __block NSMutableString *html = [NSMutableString string];
    
    [html appendFormat:@"<h3>%@</h3>",self.name];
    
    // HEADER
    if (self.flavor)
        [html appendFormat:@"<p><i>%@</i><p>",self.flavor];
    
    __block NSString *withColon = @"<b>%@:</b> %@<br>";
    
    // SPECIFICS
    [self.specifics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [obj valueForKey:@"name"];
        NSString *value = [obj valueForKey:@"value"];
        if ([self shouldDisplaySpecific:key])
            [html appendFormat:withColon, key, replace(value)];
        
    }];
    
//    if (fullText) {
//        [html appendFormat:@"<p>%@</p>",replace(fullText)];
//    }
    
    NSString *title = element.name;
    NSString *url = element.url_string;
    
    [html appendFormat:@"<p><a href=\"%@\"> Compendium Entry: %@ </a></p>",url, title];
    
    
    
    return html;
}


- (BOOL) shouldDisplaySpecific:(NSString*)key
{
    // Don't display rules elements
    if ([key hasPrefix:@"_"]) return NO;
    if ([key hasPrefix:@"Full Text"]) return NO;
    
    return YES;
}

@end
