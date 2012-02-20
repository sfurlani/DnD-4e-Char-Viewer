//
//  DNDObject.h
//  DND4e
//
//  Created by Stephen Furlani on 2/19/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RulesElement;

@interface DNDObject : NSManagedObject

@property (nonatomic, retain) NSSet *has_elements;
@end

@interface DNDObject (CoreDataGeneratedAccessors)

- (void)addHas_elementsObject:(RulesElement *)value;
- (void)removeHas_elementsObject:(RulesElement *)value;
- (void)addHas_elements:(NSSet *)values;
- (void)removeHas_elements:(NSSet *)values;
@end
