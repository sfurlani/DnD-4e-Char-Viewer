//
//  CardView.h
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Power;

@interface CardView : UIView

@property (strong, nonatomic) Power *power;
@property (assign, nonatomic) CGSize contentSize;

- (id)initWithFrame:(CGRect)frame power:(Power*)power;

@end