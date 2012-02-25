//
//  DNDAppDelegate.h
//  DND4e
//
//  Created by Stephen Furlani on 2/17/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

#define AppDelegate ((DNDAppDelegate*)[[UIApplication sharedApplication] delegate])

@interface DNDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) MainViewController *main;
@property (strong, nonatomic) NSString * mostRecentPath;

@end
