//
//  DetailViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/25/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "PageViewController.h"
#import "DNDHTML.h"

@interface DetailViewController : PageViewController <UIWebViewDelegate>

@property (strong, nonatomic) id<DNDHTML> item;

@property (strong, nonatomic) IBOutlet UIWebView *webDetail;

@end
