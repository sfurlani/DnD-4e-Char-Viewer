//
//  DNDAppDelegate.m
//  DND4e
//
//  Created by Stephen Furlani on 2/17/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "DNDAppDelegate.h"

#import "MainViewController.h"
#import "GDataXMLNode.h"
#import "XMLReader.h"
#import "Data.h"
#import "Utility.h"
#import "MBProgressHUD.h"



@implementation DNDAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize main;
@synthesize mostRecentPath;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // TODO: handle incoming data
    NSURL *url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if ([url isFileURL]) [AppData handleFileURL:url];
    
    
    NSArray *docs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: [[AppData applicationDocumentsDirectory] path] error:nil];
    NSMutableArray *dnd4eDocs = [NSMutableArray array];
    [docs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *path = obj;
        if ([[path pathExtension] isEqualToString:@"dnd4e"]) [dnd4eDocs addObject:path];
    }];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (iPad) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        self.window.rootViewController = [storyboard instantiateInitialViewController];
        
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
        self.navigationController = [storyboard instantiateInitialViewController];
        self.main = [[self.navigationController viewControllers] lastObject];
        self.window.rootViewController = self.navigationController;
    }
    
    [self.window setBackgroundColor:[UIColor blackColor]];    
    [self.window makeKeyAndVisible];

    if (![url isFileURL] || !url) {
        NSString *path = [AppDefaults objectForKey:keyLastCharacter];
        if (path)
            [AppData.delegate openFilePath:path];
    }
    
    return YES;
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url isFileURL]) [AppData handleFileURL:url];
    
    return YES;
}

		
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */

    // TODO: Fix this!!
    if (self.mostRecentPath) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading";
        [hud showWhileExecuting:@selector(openFilePath:)
                       onTarget:self.main
                     withObject:self.mostRecentPath
                       animated:YES];
        self.mostRecentPath = nil;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

@end
