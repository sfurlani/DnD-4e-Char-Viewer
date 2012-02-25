//
//  Data.m
//  DND4e
//
//  Created by Stephen Furlani on 2/18/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "Data.h"
#import "SynthesizeSingleton.h"
#import "Weapon.h"
#import "Power.h"
#import "RulesElement.h"
#import "Utility.h"

NSString * const keyAfterFirstOpen = @"KeyFirstOpen_jhadsfhjklfdsajhkldfsahjklfdsaljhkadfslhjk";

@implementation Data

SYNTHESIZE_SINGLETON_ARC(Data)

#pragma mark - non-CoreData Methods

@synthesize files;
@synthesize characters;
@synthesize delegate;


- (id) init
{
    self = [super init];
    if (self) {
        
        // Load Data
        if (![AppDefaults boolForKey:keyAfterFirstOpen]) {
            NSArray *filePaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"dnd4e" inDirectory:nil];
            [filePaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *old = obj;
                NSString *name = [old lastPathComponent];
                NSString *new = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:name];
                NSError *error = nil;
                [[NSFileManager defaultManager] copyItemAtPath:old
                                                        toPath:new 
                                                         error:&error];
                if (error) [error log];
            }];
            [AppDefaults setBool:YES forKey:keyAfterFirstOpen];
        }
        
        [self resetDocs];
    }
    return self;
}


- (void) resetDocs
{
    NSArray *docs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: [[self applicationDocumentsDirectory] path] error:nil];
    NSMutableArray *dnd4eDocs = [NSMutableArray array];
    [docs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *path = obj;
        if ([[path pathExtension] isEqualToString:@"dnd4e"]) {
            [dnd4eDocs addObject:path];
        }
    }];
    self.files = dnd4eDocs;
    if ([self.delegate conformsToProtocol:@protocol(DataFileDelegate)]) {
        [self.delegate newData:self.files];
    }
    
}

- (NSString*)nameFromPath:(NSString*)path
{
    return [[path lastPathComponent] stringByDeletingPathExtension];
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
//        self.mostRecentPath = [new path];
    }
}


#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
