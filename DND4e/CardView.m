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
    
    CGFloat yPos = 0.0f;
    CGFloat xPos = 0.0f;
    
    CGFloat border = 8.0f;
    xPos += border;
    yPos += border;
    
    CGFloat width = self.fsw - border*2.0f;
    width += 0.0f;

}


@end
