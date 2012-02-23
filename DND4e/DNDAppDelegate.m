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

NSString * const keyAfterFirstOpen = @"KeyFirstOpen_jhadsfhjklfdsajhkldfsahjklfdsaljhkadfslhjk";

@implementation DNDAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize main;
@synthesize mostRecentPath;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // TODO: handle incoming data
    NSURL *url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if ([url isFileURL]) [self handleFileURL:url];
    
    // Load Data
    if (![AppDefaults boolForKey:keyAfterFirstOpen]) {
        NSArray *filePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"dnd4e" inDirectory:nil];
        [filePaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *old = obj;
            NSString *name = [old lastPathComponent];
            NSString *new = [[[AppData applicationDocumentsDirectory] path] stringByAppendingPathComponent:name];
            NSError *error = nil;
            [[NSFileManager defaultManager] copyItemAtPath:old
                                                    toPath:new 
                                                     error:&error];
            if (error) [error log];
        }];
        [AppDefaults setBool:YES forKey:keyAfterFirstOpen];
    }
    NSArray *docs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: [[AppData applicationDocumentsDirectory] path] error:nil];
    NSMutableArray *dnd4eDocs = [NSMutableArray array];
    [docs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *path = obj;
        if ([[path pathExtension] isEqualToString:@"dnd4e"]) [dnd4eDocs addObject:path];
    }];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.main = [[MainViewController alloc] initWithData:dnd4eDocs];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.main];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url isFileURL]) [self handleFileURL:url];
    
    return YES;
}

- (void) handleFileURL:(NSURL*)url
{
    // Handle file being passed in
    NSLog(@"Handle URL: %@", url);
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //NSString *name = NSFORMAT(@"%@_%@",generateUUID(), [[url path] lastPathComponent]);
    NSString *name = [[url path] lastPathComponent];
    NSURL *new = [[AppData applicationDocumentsDirectory] URLByAppendingPathComponent:name];
    
    error = nil; // reset error
    [fileManager copyItemAtURL:url toURL:new error:&error];
    if (error) {
        [error log]; DBTrace;
    } else {
        [self resetDocs];
        self.mostRecentPath = [new path];
    }
}

- (void) resetDocs
{
    NSArray *docs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: [[AppData applicationDocumentsDirectory] path] error:nil];
    NSMutableArray *dnd4eDocs = [NSMutableArray array];
    [docs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *path = obj;
        if ([[path pathExtension] isEqualToString:@"dnd4e"]) [dnd4eDocs addObject:path];
    }];
    self.main.data = dnd4eDocs;
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
//    [self.main.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
