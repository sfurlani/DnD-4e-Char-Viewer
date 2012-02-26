//
//  DetailViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNDHTML.h"

@interface DetailViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) id<DNDHTML> item;
@property (strong, nonatomic) IBOutlet UIButton *back;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView * bg;
@property (strong, nonatomic) IBOutlet UIWebView *webDetail;

- (IBAction) back:(id)sender;

- (void) pushNewItem:(id<DNDHTML>)item;

@end
