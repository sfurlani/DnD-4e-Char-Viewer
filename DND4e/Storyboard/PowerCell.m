//
//  PowerCell.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
//

#import "PowerCell.h"
#import "Data.h"
#import "Utility.h"

@implementation PowerCell

@synthesize titleLabel, usage, attack, arrow, action;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    // Configure the view for the selected state
    UIColor *color = [UIColor colorWithWhite:0 alpha:0.8];
    if (selected) {
        color = [UIColor colorWithWhite:1.0 alpha:0.8];
    }
    if (animated) {
        [UIView animateWithDuration:1
                         animations:^{
                             [self.titleLabel setTextColor:color]; 
                         }];
    } else {
        [self.titleLabel setTextColor:color]; 
    }
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    // Configure the view for the selected state
    UIColor *color = [UIColor colorWithWhite:0 alpha:0.8];
    if (highlighted) {
        color = [UIColor colorWithWhite:1.0 alpha:0.8];
    }
    if (animated) {
        [UIView animateWithDuration:1
                         animations:^{
                             [self.titleLabel setTextColor:color]; 
                         }];
    } else {
        [self.titleLabel setTextColor:color]; 
    }
}

// TODO: if performance is an issue, make this a custom drawing method
- (void) setData:(id)data;
{
    if ([data isKindOfClass:[Power class]]) {
        Power *power = data;
        self.titleLabel.text = power.name;
        
        
        if ([power.actionType rangeOfString:@"move" options:NSCaseInsensitiveSearch].length > 0) {
            self.action.text = @"V";
        } else if ([power.actionType rangeOfString:@"standard" options:NSCaseInsensitiveSearch].length > 0) {
            self.action.text = @"S";
        } else if ([power.actionType rangeOfString:@"minor" options:NSCaseInsensitiveSearch].length > 0) {
            self.action.text = @"M";
        } else if ([power.actionType rangeOfString:@"no action" options:NSCaseInsensitiveSearch].length > 0) {
            self.action.text = @"N";
        } else if ([power.actionType rangeOfString:@"free" options:NSCaseInsensitiveSearch].length > 0) {
            self.action.text = @"F";
        } else if ([power.actionType rangeOfString:@"interrupt" options:NSCaseInsensitiveSearch].length > 0) {
            self.action.text = @"I";
        } else if ([power.actionType rangeOfString:@"opportunity" options:NSCaseInsensitiveSearch].length > 0) {
            self.action.text = @"O";
        } else if ([power.actionType rangeOfString:@"reaction" options:NSCaseInsensitiveSearch].length > 0) {
            self.action.text = @"R";
        } else {
            self.action.text = @"-";
        }
    
        if ([power.usage rangeOfString:@"At-Will"].length > 0) {
            self.usage.image = [UIImage imageNamed:@"atwill"];
        } else if ([power.usage rangeOfString:@"Encounter"].length > 0) {
            self.usage.image = [UIImage imageNamed:@"encounter"];
        } else if ([power.usage rangeOfString:@"Daily"].length > 0) {
            self.usage.image = [UIImage imageNamed:@"daily"];
        } else {
            self.usage.image = nil;
        }
        
        if ([power.attackType rangeOfString:@"Melee"].length > 0 && 
            [power.attackType rangeOfString:@"Ranged"].length > 0) {
            self.attack.image = [UIImage imageNamed:@"meleeranged"];
            
        } else if ([power.attackType rangeOfString:@"Melee"].length > 0) {
            self.attack.image = [UIImage imageNamed:@"melee"];
        } else if ([power.attackType rangeOfString:@"Ranged"].length > 0) {
            self.attack.image = [UIImage imageNamed:@"ranged"];
        } else if ([power.attackType rangeOfString:@"Close"].length > 0) {
            self.attack.image = [UIImage imageNamed:@"close"];
        } else if ([power.attackType rangeOfString:@"Area"].length > 0) {
            self.attack.image = [UIImage imageNamed:@"area"];
        } else {
            self.attack.image = nil;
        }
    } else if ([data isKindOfClass:[Loot class]]) {
        Loot *loot = data;
        self.titleLabel.text = [loot magicName];
        self.usage.image = [UIImage imageNamed:@"weapon"];
        self.attack.image = nil;
        self.action.text = @"";
    }
    
    if (iPhone)
        self.arrow.image = [UIImage imageNamed:@"arrow"];
    
}


@end
