//
//  PowerCell.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
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
