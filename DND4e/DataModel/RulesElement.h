//
//  RulesElement.h
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RulesElement : NSObject

@property (nonatomic, strong) NSNumber * charelem;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * internal_id;
@property (nonatomic, strong) NSNumber * legal;
@property (nonatomic, strong) NSString * url_string;
@property (nonatomic, strong) NSMutableArray *specifics;

- (id) initWithDictionary:(NSDictionary*)info;
- (void) populateWithDictionary:(NSDictionary *)info;

@end
