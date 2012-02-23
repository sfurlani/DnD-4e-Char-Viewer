//
//  HelpViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/23/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *appVersion;
@property (strong, nonatomic) IBOutlet UILabel *fileVersion;
@property (strong, nonatomic) IBOutlet UIWebView *webHelp;

- (IBAction) back:(id)sender;

@end
