//
//  Loot.m
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

#import "Loot.h"
#import "Data.h"
#import "Utility.h"

#define replace(string) ([[string stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"] stringByReplacingOccurrencesOfString:@"\t" withString:@"&nbsp;&nbsp;&nbsp;&nbsp;"])

@implementation Loot

@synthesize items, element;
@synthesize character;
@synthesize numCount, equipCount, showPowerCard;

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
    //<loot count="1" equip-count="0" ShowPowerCard="1" >
    self.showPowerCard = [[info valueForKey:@"ShowPowerCard"] boolValue];
    self.numCount = [[info valueForKey:@"count"] numberValue];
    self.equipCount = [[info valueForKey:@"equip-count"] numberValue];
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

- (NSString*) shortname
{
    if ([items count] > 0)
        return [[self.items objectAtIndex:0] name];
    else
        return @"";
}

- (NSString*) magicName
{
    __block NSString *name = nil;
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Item *item = obj;
        if ([item.type isEqualToString:@"Magic Item"]) {
            name = item.name;
            *stop = YES; 
        }
    }];
    return name;
}

- (BOOL) isMagic
{
    return ([self magicItem] != nil);
}

- (Item*) magicItem
{
    __block Item *magic = nil;
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Item *item = obj;
        if ([item.type isEqualToString:@"Magic Item"]) {magic = item; *stop = YES; }
    }];
    return magic;
}

@end

@implementation Item

@synthesize name, flavor, fullText;
@synthesize element;
@synthesize specifics;
@synthesize type;

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
    self.type = [info valueForKey:@"type"];
    id specs = [info valueForKey:@"specific"];
    [specs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [obj valueForKey:@"name"];
        NSString *value = [obj valueForKey:kXMLReaderTextNodeKey];
        
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
        [html appendFormat:@"<div style=\"background-color:rgba(44,44,44,.12)\"><i>%@</i></div>",self.flavor];
    
    __block int count = 0;
    __block NSString *row = @"<dt><b>%@:</b> %@</dt>";
    __block NSString *rowG = @"<dt style=\"background-color:rgba(44,44,44,.12)\"><b>%@:</b> %@</dt>";
#define rowColor ((count++)%2 == 0 ? row : rowG)
    
    // SPECIFICS
    [self.specifics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = [obj valueForKey:@"name"];
        NSString *value = [obj valueForKey:kXMLReaderTextNodeKey];
        if ([self shouldDisplaySpecific:key])
            [html appendFormat:rowColor, key, replace(value)];
        
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
