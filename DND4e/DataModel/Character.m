//
//  Character.m
//  DND4e
//
//  Created by Stephen Furlani on 2/20/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import "Character.h"
#import "Data.h"
#import "XMLReader.h"

@implementation Character

@synthesize name;
@synthesize powers, loot;

- (id) initWithFile:(NSString *)path
{
    self = [super init];
    if (self) {
        NSData *xmlData = [[NSData alloc] initWithContentsOfFile:path];
        NSError *error = nil;
        NSDictionary *data = [XMLReader dictionaryForXMLData:xmlData error:&error];
        
        NSArray *powerInfo = [data valueForKeyPath:@"D20Character.CharacterSheet.PowerStats.Power"];
        self.powers = [NSMutableArray arrayWithCapacity:[powerInfo count]];
        [powerInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Power *power = [[Power alloc] initWithDictionary:obj];
            [self.powers addObject:power];
            power.character = self; // weak
        }];
        
        NSArray *lootInfo = [data valueForKeyPath:@"D20Character.CharacterSheet.LootTally.loot"];
        self.loot = [NSMutableArray arrayWithCapacity:[lootInfo count]];
        [lootInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Loot *item = [[Loot alloc] initWithDictionary:obj];
            [self.loot addObject:item];
            item.character = self; // weak
        }];
        
        self.name = [data valueForKeyPath:@"D20Character.CharacterSheet.Details.name.value"];
        
    }
    return self;
}

- (NSString*) html
{
    return @"";
}

- (Loot*) lootForInternalID:(NSString*)internalID
{
    __block Loot *ret = nil;
    [self.loot enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Loot *lt = obj;
        [lt.items enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx, BOOL *stop) {
            Item *it = obj2;
            if ([it.element.internal_id isEqualToString:internalID]) {
                ret = obj;
                *stop = YES;
            }
        }];
        if (ret) *stop = YES;
    }];
    return ret;
}

@end
