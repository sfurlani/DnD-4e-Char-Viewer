//
//  ScoresViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewController.h"

@interface ScoresViewController : PageViewController

@property (strong, nonatomic) IBOutlet UIButton *strDetail;
@property (strong, nonatomic) IBOutlet UIButton *conDetail;
@property (strong, nonatomic) IBOutlet UIButton *dexDetail;
@property (strong, nonatomic) IBOutlet UIButton *intDetail;
@property (strong, nonatomic) IBOutlet UIButton *wisDetail;
@property (strong, nonatomic) IBOutlet UIButton *chaDetail;

@property (strong, nonatomic) IBOutlet UILabel *strScore;
@property (strong, nonatomic) IBOutlet UILabel *conScore;
@property (strong, nonatomic) IBOutlet UILabel *dexScore;
@property (strong, nonatomic) IBOutlet UILabel *intScore;
@property (strong, nonatomic) IBOutlet UILabel *wisScore;
@property (strong, nonatomic) IBOutlet UILabel *chaScore;

@property (strong, nonatomic) IBOutlet UILabel *strMod;
@property (strong, nonatomic) IBOutlet UILabel *conMod;
@property (strong, nonatomic) IBOutlet UILabel *dexMod;
@property (strong, nonatomic) IBOutlet UILabel *intMod;
@property (strong, nonatomic) IBOutlet UILabel *wisMod;
@property (strong, nonatomic) IBOutlet UILabel *chaMod;


- (void) refresh;

@end
