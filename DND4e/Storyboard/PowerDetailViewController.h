//
//  PowerDetailViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PageViewController.h"

@class Power;

@interface PowerDetailViewController : PageViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webPower;
@property (strong, nonatomic) Power *power;

- (void) loadHTML:(NSString*)string;

@end
