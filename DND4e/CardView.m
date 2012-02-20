//
//  CardView.m
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "CardView.h"
#import "Data.h"
#import "Power.h"
#import "Utility.h"

@implementation CardView

@synthesize power = _power;

- (id)initWithFrame:(CGRect)frame power:(Power*)power
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.power = power;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (!_power) return;
    
    UIFont *bold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    UIFont *italics = [UIFont fontWithName:@"HelveticaNeue-Italic" size:12.0f];
    UIFont *normal = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    
    
    CGFloat yPos = 0.0f;
    CGFloat xPos = 0.0f;
    
    CGFloat border = 8.0f;
    xPos += border;
    yPos += border;
    
    CGFloat width = self.fsw - border*2.0f;
    width += 0.0f;
    
    // draw Background?
//    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    // FLAVOR TEXT & Init
    [[UIColor blackColor] setFill];
    __block CGRect new_rect = CGRectMake(yPos, xPos, 0,0);
    __block CGSize new_size = CGSizeMake(width, NSIntegerMax);
    new_rect.size = new_size;
    __block NSString *print = _power.flavor;
    __block CGSize offset = [print drawInRect:new_rect
                             withFont:italics
                        lineBreakMode:UILineBreakModeWordWrap];
    
    // USAGE & ACTION TYPE
    void (^printOut)(NSString*, NSString*, UIFont*) = ^(NSString* header, NSString* text, UIFont* font){
        new_rect.origin.x = border;
        new_rect.origin.y += offset.height + border;
        new_rect.size = new_size;
        
        if (header) {
            offset = [header drawInRect:new_rect
                               withFont:bold
                          lineBreakMode:UILineBreakModeWordWrap];
            new_rect.origin.x += offset.width;
            new_rect.size.width -= offset.width;
        }
        
        offset = [text drawInRect:new_rect
                          withFont:font
                     lineBreakMode:UILineBreakModeWordWrap];
    };
    if (_power.usage || _power.actionType)
        printOut(nil,NSFORMAT(@"%@ * %@", [_power usage], [_power actionType]),normal);
    
    
    // KEYWORDS
    if (_power.keywords && [_power.keywords length] > 2)
        printOut(@"Keywords: ",_power.keywords,normal);
    
    
    // ATTACK TYPE
    if (_power.attackType) {
        NSMutableArray *words = [[[_power attackType] componentsSeparatedByString:@" "] mutableCopy];
        NSString *first = [words objectAtIndex:0];
        [words replaceObjectAtIndex:0 withObject:@" "];
        NSString *rest = [words componentsJoinedByString:@" "];
        printOut(first, rest, normal);
    }
    
    // TARGET
    if (_power.target)
        printOut(@"Target: ", _power.target, normal);
    
    // ATTACK
    if (_power.attack)
        printOut(@"Attack: ", _power.attack, normal);
    
    // HIT
    if (_power.hit)
        printOut(@"Hit: ", _power.hit, normal);
    
    // EFFECT
    if (_power.effect)
        printOut(@"Effect: ", _power.effect, normal);
    
    // WEAPON
    if (_power.selected_weapon) {
        NSString *name = NSFORMAT(@"%@: ", _power.selected_weapon.name);
        NSString *bonus = ([_power.selected_weapon.attackBonus intValue] > 0 ? 
                           NSFORMAT(@"+%@", _power.selected_weapon.attackBonus) : 
                           _power.selected_weapon.attackBonus);
        NSString *text = NSFORMAT(@"%@ vs. %@, %@ damage", 
                                  bonus,
                                  _power.selected_weapon.defense,
                                  _power.selected_weapon.damage);
        printOut(name, text, normal);
        
        // CONDITIONALS
        printOut(nil,@"Additional Effects:",bold);
        new_rect.origin.y -= border; // back up
        printOut(nil,_power.selected_weapon.conditions, italics);
    }

}


@end
