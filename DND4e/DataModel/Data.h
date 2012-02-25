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
#import "Skill.h"
#import "Stat.h"

#define AppData ([Data sharedData])

@protocol DataFileDelegate;

@interface Data : NSObject

+ (Data*) sharedData;

- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) NSArray *files;
@property (strong, nonatomic) NSMutableDictionary *characters;
@property (unsafe_unretained, nonatomic) id<DataFileDelegate> delegate;


- (void) resetDocs;
- (NSString*)nameFromPath:(NSString*)path;
- (void) handleFileURL:(NSURL*)url;
- (Character*)loadCharacterWithFile:(NSString*)path;

@end

@protocol DataFileDelegate <NSObject>

- (void) newData:(NSArray*)files;

@end

#define replace(string) ([[string stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"] stringByReplacingOccurrencesOfString:@"\t" withString:@"&nbsp;&nbsp;&nbsp;&nbsp;"])
