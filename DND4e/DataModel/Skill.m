//
//  Skill.m
//  DND4e
//
//  Created by Stephen Furlani on 2/21/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
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
