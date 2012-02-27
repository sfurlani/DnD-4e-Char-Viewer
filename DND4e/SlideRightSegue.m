//
//  SlideRightSegue.m
//  AURTA
//
//  Created by Stephen Furlani on 1/27/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "SlideRightSegue.h"

@implementation SlideRightSegue

- (void) perform
{
    UINavigationController *nav = [self.sourceViewController navigationController];
    NSParameterAssert(nav);
    
    NSArray *vcs = [nav viewControllers];
    // Don't Copy.  Use original objects
    NSMutableArray *new_vcs = [NSMutableArray array];
    [vcs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqual:self.sourceViewController]) { // replace source w/destination
            [new_vcs addObject:self.destinationViewController];
            [new_vcs addObject:self.sourceViewController];
        } else {
            [new_vcs addObject:obj];
        }
    }];
    
    [nav setViewControllers:new_vcs animated:NO];
    [nav popToViewController:self.destinationViewController animated:YES];
    
}

@end
