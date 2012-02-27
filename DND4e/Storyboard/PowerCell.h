//
//  PowerCell.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Power;

@interface PowerCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *usage;
@property (strong, nonatomic) IBOutlet UIImageView *attack;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;

- (void) setData:(id)data;

@end
