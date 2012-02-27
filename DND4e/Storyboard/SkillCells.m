//
//  SkillCells.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "SkillCells.h"

@implementation SkillCells

@synthesize skillTitle, skillValue, arrow;

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
                             [self.skillTitle setTextColor:color]; 
                             [self.skillValue setTextColor:color]; 
                         }];
    } else {
        [self.skillTitle setTextColor:color]; 
        [self.skillValue setTextColor:color];
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
                             [self.skillTitle setTextColor:color];
                             [self.skillValue setTextColor:color]; 
                         }];
    } else {
        [self.skillTitle setTextColor:color]; 
        [self.skillValue setTextColor:color];
    }
}


- (void) didMoveToWindow
{
    self.arrow.image = [UIImage imageNamed:@"arrow"];
}

@end
