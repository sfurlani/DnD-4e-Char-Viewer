//
//  FileCell.m
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "FileCell.h"

@implementation FileCell

@synthesize fileTitle, arrow;

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
    UIColor *color = [UIColor colorWithWhite:0 alpha:0.8];
    if (selected) {
        color = [UIColor colorWithWhite:1.0 alpha:0.8];
    }
    if (animated) {
        [UIView animateWithDuration:1
                         animations:^{
                                    [self.fileTitle setTextColor:color]; 
                         }];
    } else {
        [self.fileTitle setTextColor:color]; 
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
                             [self.fileTitle setTextColor:color]; 
                         }];
    } else {
        [self.fileTitle setTextColor:color]; 
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    BOOL hide = NO;
    if (editing) {
        hide = YES;
    }
    if (animated) {
        [UIView animateWithDuration:0.1
                         animations:^{
                             [self.arrow setHidden:hide]; 
                         }];
    } else {
        [self.arrow setHidden:hide];
    }
    
}

- (void) didMoveToWindow
{
    self.arrow.image = [UIImage imageNamed:@"arrow"];
}

@end
