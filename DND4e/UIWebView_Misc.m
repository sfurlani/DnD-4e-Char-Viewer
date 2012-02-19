//
//  UIWebView_NoShadow.m
//  kubota
//
//  Created by Stephen Furlani on 8/14/11.
//  Copyright 2011 Accella, LLC. All rights reserved.
//

#import "UIWebView_Misc.h"

// A lot of this isn't necessary for iOS 5

@implementation UIWebView (UIWebView_Misc)

- (void) setShadowHidden:(BOOL)hide
{
//    for (UIView* subView in [self subviews])
//        if ([subView isKindOfClass:[UIScrollView class]])
            for (UIView* shadowView in [self.scrollView subviews])
                if ([shadowView isKindOfClass:[UIImageView class]])
                    [shadowView setHidden:hide];
}

- (void) setAllBackgroundColors:(UIColor*)color
{
    for (UIView* subView in [self subviews])
        [subView setBackgroundColor:color];
}

- (void) setBounceDisabled:(BOOL)disabled
{
//    for (UIView* subView in [self subviews])
//        if ([subView isKindOfClass:[UIScrollView class]]) {
//            ((UIScrollView*)subView).alwaysBounceVertical = !disabled;
//            ((UIScrollView*)subView).alwaysBounceHorizontal = !disabled;
//        }
    
    self.scrollView.alwaysBounceHorizontal = !disabled;
    self.scrollView.alwaysBounceVertical = !disabled;
}

- (void) setScrollStyle:(UIScrollViewIndicatorStyle)style
{
    self.scrollView.indicatorStyle = style;
//    for (UIView* subView in [self subviews])
//        if ([subView isKindOfClass:[UIScrollView class]]) {
//            [((UIScrollView*)subView) setIndicatorStyle:style];
//        }
}

@end
