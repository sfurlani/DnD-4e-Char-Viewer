//
//  Data.m
//  DND4e
//
//  Created by Stephen Furlani on 2/18/12.
/*
 
Copyright © 2012 Stephen Furlani. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. The name of the author may not be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Stephen Furlani "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
//

#import "Data.h"
#import "SynthesizeSingleton.h"
#import "Weapon.h"
#import "Power.h"
#import "RulesElement.h"
#import "Utility.h"
#import "DNDAppDelegate.h"
#import "MBProgressHUD.h"

NSString * const keyAfterFirstOpen = @"KeyFirstOpen_jhadsfhjklfdsajhkldfsahjklfdsaljhkadfslhjk";
NSString * const keyLastCharacter = @"keyLastCharacter";

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
        self.characters = [NSMutableDictionary dictionaryWithCapacity:[self.files count]];
    }
    return self;
}


- (void) resetDocs
{
    NSArray *docs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: [[self applicationDocumentsDirectory] path] error:nil];
    NSMutableArray *dnd4eDocs = [NSMutableArray array];
    [docs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *file = obj;
        if ([[file pathExtension] isEqualToString:@"dnd4e"]) {
            NSString *path = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:file];
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
    NSURL *new = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:name];
    
    error = nil; // reset error
    [fileManager copyItemAtURL:url toURL:new error:&error];
    if (error) {
        [error log]; DBTrace;
    } else {
        [fileManager removeItemAtURL:url error:&error];
        [self resetDocs];
        if (delegate) {
            [delegate openFilePath:[new path]];
        }
    }
}

- (Character*)loadCharacterWithFile:(NSString*)path
{
    NSString *name = [self nameFromPath:path];
    [AppDefaults setObject:path forKey:keyLastCharacter];
    [AppDefaults synchronize];
    Character *character = [self.characters objectForKey:name];
    if (!character) {
        NSLog(@"Creating: %@", name);
        
        //MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:AppDelegate.navigationController.view];
        //hud.mode = MBProgressHUDModeIndeterminate;
        //hud.labelText = @"Loading";
        //[AppDelegate.navigationController.view addSubview:hud];
        //[hud show:YES];
        character = [[Character alloc] initWithFile:path];
//        [hud showWhileExecuting:@selector(initWithFile:)
//                       onTarget:character
//                     withObject:path
//                       animated:YES];
        [self.characters setObject:character forKey:name];
        //[hud hide:YES afterDelay:0.3];
    } else {
        NSLog(@"Loading: %@", name);
    }
    return character;
}

- (BOOL) deleteFileAtPath:(NSString*)path
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    //NSLog(@"Path to file: %@", path);        
    //NSLog(@"File exists: %d", fileExists);
    //NSLog(@"Is deletable file at path: %d", [fileManager isDeletableFileAtPath:path]);
    BOOL success = NO;
    if (fileExists) 
    {
        success = [fileManager removeItemAtPath:path error:&error];
        if (success) NSLog(@"Deleted file at Path: %@", path);
        
    }
    
    return success && !error;
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
