//
//  Data.h
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

extern NSString * const keyLastCharacter;

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

- (BOOL) deleteFileAtPath:(NSString*)path;

@end

@protocol DataFileDelegate <NSObject>

- (void) newData:(NSArray*)files;
- (void) openFilePath:(NSString*)path;

@end

#define replace(string) ([[string stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"] stringByReplacingOccurrencesOfString:@"\t" withString:@"&nbsp;&nbsp;&nbsp;&nbsp;"])
