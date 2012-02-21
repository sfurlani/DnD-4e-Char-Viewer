//
//  DNDAppDelegate.m
//  DND4e
//
//  Created by Stephen Furlani on 2/17/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "DNDAppDelegate.h"

#import "DictionaryExplorerViewController.h"
#import "PowerCardViewController.h"
#import "GDataXMLNode.h"
#import "XMLReader.h"
#import "Data.h"

@implementation DNDAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSArray *filePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"dnd4e" inDirectory:nil];
    NSMutableArray * characters = [NSMutableArray arrayWithCapacity:[filePaths count]];
    [filePaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSData *xmlData = [[NSData alloc] initWithContentsOfFile:obj];
        NSError *error = nil;
        NSDictionary *data = [XMLReader dictionaryForXMLData:xmlData error:&error];
        
        NSArray *powers = [data valueForKeyPath:@"D20Character.CharacterSheet.PowerStats.Power"];
        NSMutableArray *powerObjs = [NSMutableArray arrayWithCapacity:[powers count]];
        [powers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Power *power = [[Power alloc] initWithDictionary:obj];
            [powerObjs addObject:power];
        }];
        
        NSArray *loot = [data valueForKeyPath:@"D20Character.CharacterSheet.LootTally.loot"];
        NSMutableArray *lootObjs = [NSMutableArray arrayWithCapacity:[loot count]];
        [loot enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Loot *item = [[Loot alloc] initWithDictionary:obj];
            [lootObjs addObject:item];
        }];
        
        NSString *name = [data valueForKeyPath:@"D20Character.CharacterSheet.Details.name.value"];
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              name,@"name",
                              powerObjs,@"Power Cards",
                              lootObjs,@"Inventory",
                              [data valueForKeyPath:@"D20Character"],@"Object Graph (ref only)",
                              nil];
        [characters addObject:info];
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    DictionaryExplorerViewController *vc = [[DictionaryExplorerViewController alloc] initWithData:characters];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [AppData saveContext];
}

@end
