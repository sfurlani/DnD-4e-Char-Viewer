//
//  PowerCardViewController.h
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNDHTML.h"

@class Power;

@interface PowerCardViewController : UIViewController <UIActionSheetDelegate, UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *cardView;
@property (strong, nonatomic) id<DNDHTML> thing;

- (id)initWithThing:(id<DNDHTML>)thing;

@end
