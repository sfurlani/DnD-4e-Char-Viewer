//
//  Skill.m
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
//

#import "Skill.h"
#import "Data.h"
#import "Utility.h"

@implementation Skill

@synthesize name = _name;
@synthesize character = _character;
@synthesize components;
@synthesize bonus = _bonus;
@synthesize element;
@synthesize trained;

- (id) initWithName:(NSString*)name
{
    self = [super init];
    if (self) {
        self.name = name;
        self.components = nil;
    }
    return self;
}

- (void) populateFromCharacter:(Character*)character
{
    self.character = character;
    NSDictionary *stats = character.stats;
    Stat *stat = [stats objectForKey:self.name];
    self.element = [character.elements objectAtIndex:[character.elements indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        *stop = [[obj name] isEqualToString:self.name];
        return *stop;
    }]];
    self.bonus = NSINT([stat value]);
    self.trained = NO;
    [character.elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RulesElement *el = obj;
        if ([el.name isEqualToString:self.name] &&
            [el.type isEqualToString:@"Skill Training"]) {
            self.trained = YES;
            *stop = YES;
        }
    }];
                              
//    NSLog(@"Stat: %@ - %@", stat.name, self.bonus);
}


- (NSString*) html
{
    __block NSMutableString *html = [NSMutableString string];
    
    [html appendFormat:@"<h3>Total %@: %@</h3><b>Breakdown:</b><br>",self.name, PFORMAT(self.bonus)];
    [html appendString:[[self.character.stats objectForKey:self.name] html]];
    [html appendString:[self.element html]];
    
    return html;
}

@end
