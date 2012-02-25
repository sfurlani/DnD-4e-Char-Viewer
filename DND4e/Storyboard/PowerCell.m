//
//  PowerCell.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PowerCell.h"
#import "Data.h"


@implementation PowerCell

@synthesize titleLabel, usage, attack, arrow;

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
}

// TODO: if performance is an issue, make this a custom drawing method
- (void) setPower:(Power*)power
{
    self.titleLabel.text = power.name;
    
    if ([power.usage rangeOfString:@"At-Will"].length > 0) {
        self.usage.image = [UIImage imageNamed:@"atwill"];
    } else if ([power.usage rangeOfString:@"Encounter"].length > 0) {
        self.usage.image = [UIImage imageNamed:@"encounter"];
    } else if ([power.usage rangeOfString:@"Daily"].length > 0) {
        self.usage.image = [UIImage imageNamed:@"daily"];
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
    
    self.arrow.image = [UIImage imageNamed:@"arrow"];
    
}


@end
