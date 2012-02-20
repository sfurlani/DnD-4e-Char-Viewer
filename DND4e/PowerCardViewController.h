//
//  PowerCardViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardView, Power;

@interface PowerCardViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet CardView *cardView;
@property (strong, nonatomic) Power *power;

- (id)initWithPower:(Power*)power;

@end
