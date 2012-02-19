//
//  RulesElement.h
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RulesElement : NSManagedObject

@property (nonatomic, retain) NSNumber * charelem;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * elemname;
@property (nonatomic, retain) NSString * internal_id;
@property (nonatomic, retain) NSNumber * legal;
@property (nonatomic, retain) NSString * url_string;

@end
