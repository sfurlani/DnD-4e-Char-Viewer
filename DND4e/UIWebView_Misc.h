//
//  UIWebView_NoShadow.h
//  kubota
//
//  Created by Stephen Furlani on 8/14/11.
//  Copyright 2011 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (UIWebView_Misc)

- (void) setShadowHidden:(BOOL)hide;
- (void) setAllBackgroundColors:(UIColor*)color;
- (void) setBounceDisabled:(BOOL)disabled;
- (void) setScrollStyle:(UIScrollViewIndicatorStyle)style;
@end
