//
//  Utility.m
//  General Applications
//
//  Created by Stephen Furlani on 11/10/11.
//  Copyright (c) 2011 Accella, LLC. All rights reserved.
//

#import "Utility.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <objc/runtime.h>

id interfaceIdiom(id iphone, id ipad) {
    // returns two objects based on if iphone or ipad.
    return (iPhone) ? iphone : ipad;
}

inline BOOL isNilOrNull(id object)
{
    // returns from NSDictionaries and NSManagedObjects can sometimes be null ([NSNull null] != nil)
    return (object == nil || object == [NSNull null]);
}

inline BOOL isValid(id object)
{
    // returns from NSDictionaries and NSManagedObjects can sometimes be null ([NSNull null] != nil)
    return (object != nil && object != [NSNull null]);
}

inline BOOL hasTextualValue(NSString *string)
{
    // Useful for JSON object returns and knowing if a string actually contains anything worthwhile
    return !(string == nil || string == (id)[NSNull null] ||
             [string length] == 0 || [string isEqualToString:@""] ||
             [string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"]);
}

float getTotalDiskSpaceInBytes()
{  
    float totalSpace = 0.0f;  
    NSError *error = nil;  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];  
    
    if (dictionary) {  
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];  
        totalSpace = [fileSystemSizeInBytes floatValue];  
    } else {  
        ERLog(@"Error Obtaining File System Info: Domain = %@, Code = %@", [error domain], [error code]);  
    }  
    
    return totalSpace;  
}  

// return a new autoreleased UUID string
inline NSString* generateUUID(void)
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef that you own
    CFStringRef uuidCFString = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    // transfer ownership of the string by bridging it to ARC
    NSString *uuidString = [(__bridge_transfer NSString *)uuidCFString copy];
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}


inline CGFloat systemVersion() { return SYSTEM_VERSION; }

////  Not needed for iOS 5+
//id SFJSONDecode(NSData *data, NSError **error)
//{
//    // Include SBJSON.framework
//    id JSON = nil;
//    
////    if (iOS_5) {
//        JSON = [NSJSONSerialization JSONObjectWithData:data 
//                                               options:NSJSONReadingMutableContainers 
//                                                 error:error];
////    } else {
////        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
////        JSON = [[SBJsonParser new] objectWithString:str error:error];
////    }
//    
//    return JSON;
//}


@implementation NSString (Number_Shortcut)

- (NSNumber*) numberValue
{
    if ([self rangeOfString:@"."].location != NSNotFound)
        return [self numberValueWithType:tDouble];
    else
        return [self numberValueWithType:tLongLong];
}

- (NSNumber*) numberValueWithType:(tNumberType)type
{
    switch (type) {
        case tFloat:
            return [NSNumber numberWithFloat:[self floatValue]];
        case tDouble:
            return [NSNumber numberWithDouble:[self doubleValue]];
        case tInt:
            return [NSNumber numberWithInt:[self intValue]];
        case tLongLong:
            return [NSNumber numberWithLongLong:[self longLongValue]];
        case tBOOL:
            return [NSNumber numberWithBool:[self boolValue]];
        case tNSInteger:
            return [NSNumber numberWithInteger:[self integerValue]];
        default:
            return nil;
    }
}

@end

@implementation UIDevice (machine_version)

- (BOOL) supportsCameraFocus
{
    NSString *machine = [self machine];
    
     #define IPHONE_SIM	@"i386"	 //480×320 res
     #define IPHONE_LION_SIM @"x86_64"
     
     #define IPHONE_BASE @"iPhone1,1"	//480×320 res
     #define IPHONE_3G	@"iPhone1,2"	//480×320 res
     #define IPHONE_3GS @"iPhone2,1"	//480×320 res
     #define IPHONE_4_GSM	@"iPhone3,1"	//960×640 res (retina display)
     #define IPHONE_4_CDMA	@"iPhone3,3"	//960×640 res (retina display)
     #define IPHONE_4S   @"iPhone4,1"    //960x640 res (retina display)
     
     #define IPOD_GEN1	@"iPod1,1"	 //480×320 res
     #define IPOD_GEN2	@"iPod2,1"	 //480×320 res
     #define IPOD_GEN3	@"iPod3,1"	 //480×320 res
     #define IPOD_GEN4	@"iPod4,1"	 //960×640 res (retina display)
     
     #define IPAD1	 @"iPad1,1"	 //1024×768 res
     #define IPAD2_CDMA	 @"iPad2,3"	 //1024×768 res
     #define IPAD2_GSM   @"iPad2,2"
    
    if ([machine isEqualToString:IPHONE_3GS] ||
        [machine isEqualToString:IPHONE_4_GSM] ||
        [machine isEqualToString:IPHONE_4_CDMA] ||
        [machine isEqualToString:IPHONE_4S] ||
        [machine isEqualToString:IPOD_GEN4] ||
        [machine isEqualToString:IPAD2_CDMA] ||
        [machine isEqualToString:IPAD2_GSM]){
        DBLog(@"Device: %@, supports Camera Focus", machine);
        
        return YES;
    }
    DBLog(@"Device: %@, DOES NOT support Camera Focus", machine);
    return NO;
}

- (NSString *)machine
{
    size_t size;
    
    // Set 'oldp' parameter to NULL to get the size of the data
    // returned so we can allocate appropriate amount of space
    sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
    
    // Allocate the space to store name
    char *name = malloc(size);
    
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    // Place name into a string
    NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    
    // Done with this
    free(name);
    
    return machine;
}

@end


CGRect aspectFittedRect(CGRect inRect, CGRect maxRect)
{
	float originalAspectRatio = inRect.size.width / inRect.size.height;
	float maxAspectRatio = maxRect.size.width / maxRect.size.height;
    
	CGRect newRect = maxRect;
	if (originalAspectRatio > maxAspectRatio) { // scale by width
		newRect.size.height = maxRect.size.width * inRect.size.height / inRect.size.width;
		newRect.origin.y += (maxRect.size.height - newRect.size.height)/2.0;
	} else {
		newRect.size.width = maxRect.size.height  * inRect.size.width / inRect.size.height;
		newRect.origin.x += (maxRect.size.width - newRect.size.width)/2.0;
	}
    
	return CGRectIntegral(newRect);
}

@implementation NSError (UserLogging)

- (void) log
{
    ERLog(@"(%d) %@", self.code, self.localizedDescription);
    
}

- (void) logDeep
{
    [self log];
    ERLog(@"%@", self);
    
}

@end


@implementation NSObject (PropertyListing)

- (NSDictionary *)properties_aps {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

@end

