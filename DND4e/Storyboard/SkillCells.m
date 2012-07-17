//
//  SkillCells.m
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

#import "SkillCells.h"
#import "Utility.h"

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
//    if (animated) {
//        [UIView animateWithDuration:1
//                         animations:^{
//                             [self.skillTitle setTextColor:color]; 
//                             [self.skillValue setTextColor:color]; 
//                         }];
//    } else {
        [self.skillTitle setTextColor:color]; 
        [self.skillValue setTextColor:color];
//    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    // Configure the view for the selected state
    UIColor *color = [UIColor colorWithWhite:0 alpha:0.8];
    if (highlighted) {
        color = [UIColor colorWithWhite:1.0 alpha:0.8];
    }
//    if (animated) {
//        [UIView animateWithDuration:1
//                         animations:^{
//                             [self.skillTitle setTextColor:color];
//                             [self.skillValue setTextColor:color]; 
//                         }];
//    } else {
        [self.skillTitle setTextColor:color]; 
        [self.skillValue setTextColor:color];
//    }
}


- (void) didMoveToWindow
{
    if (iPhone)
        self.arrow.image = [UIImage imageNamed:@"arrow"];
}

@end
