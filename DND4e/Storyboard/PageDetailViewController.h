//
//  PageDetailViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PageViewController.h"

@protocol DNDHTML;

@interface PageDetailViewController : PageViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webDetail;
@property (strong, nonatomic) id<DNDHTML> item;

- (void) loadHTML:(NSString*)string;

@end
