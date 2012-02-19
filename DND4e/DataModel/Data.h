//
//  Data.h
//  DND4e
//
//  Created by Stephen Furlani on 2/18/12.
//  Copyright (c) 2012 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppData ([Data sharedData])

@interface Data : NSObject

+ (Data*) sharedData;

@end
