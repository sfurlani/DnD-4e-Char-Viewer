//
//  PageDetailViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PageViewController.h"
#import "ListViewController.h"
@protocol DNDHTML, ListViewController;

@interface PageDetailViewController : PageViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webDetail;
@property (strong, nonatomic) id<DNDHTML> item;
@property (strong, nonatomic) ListViewController *listVC;

- (void) loadHTML:(NSString*)string;

- (IBAction)swipeLeft:(UIGestureRecognizer*)gesture;
- (IBAction)swipeRight:(UIGestureRecognizer*)gesture;

@end
