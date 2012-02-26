//
//  SkillCells.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillCells : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *skillTitle;
@property (strong, nonatomic) IBOutlet UILabel *skillValue;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;

@end
