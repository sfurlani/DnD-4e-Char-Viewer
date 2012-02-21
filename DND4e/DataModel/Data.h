//
//  Data.h
//  DND4e
//
//  Created by Stephen Furlani on 2/18/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weapon.h"
#import "Power.h"
#import "RulesElement.h"
#import "Loot.h"
#import "Character.h"
#import "AbilityScores.h"

#define AppData ([Data sharedData])

@interface Data : NSObject

+ (Data*) sharedData;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
