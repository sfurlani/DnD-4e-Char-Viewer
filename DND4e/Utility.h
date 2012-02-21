//
//  Utility.h
//  General Applications
//
//  Created by Stephen Furlani on 11/10/11.
//  Copyright (c) 2011 Accella, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


/* Shell Script for marking TODO FIXME ??? !!! as Warnings
 
 #http://deallocatedobjects.com/2011/05/11/show-todos-and-fixmes-as-warnings-in-xcode-4/
 KEYWORDS="TODO_:|FIXME_:|\?\?\?:|\!\!\!:" # Remove the "_"
 find "${SRCROOT}" \( -name "*.h" -or -name "*.m" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($KEYWORDS).*\$" | perl -p -e "s/($KEYWORDS)/ warning: \$1/"
 
 */

#define FONT_DND @"D&D 4e icons"

////////////////////////////////////////////////////////////////////////////////
// Client-specific macros, like fonts, colors, etc.

//#define MMMOrangeColor [UIColor colorWithRed:0.89 green:0.55 blue:0.12 alpha:1.0]
//#define FONTSIZE ((iPad)?24:16)
//#define MMMSystemFont [UIFont systemFontOfSize:FONTSIZE]
#define ISWHITE ([UIColor whiteColor])
#define ISGRAY_LT ([UIColor colorWithRed:(162.0f/255.0f) green: (163.0f/255.0f) blue:(166.0f/255.0f) alpha:1.0f])
#define ISGRAY_DK ([UIColor colorWithRed:(89.0f/255.0f) green: (89.0f/255.0f) blue:(89.0f/255.0f) alpha:1.0f])
#define ISBLUE ([UIColor colorWithRed:(13.0f/255.0f) green: (21.0f/255.0f) blue:(69.0f/255.0f) alpha:1.0f])
#define ISCYAN ([UIColor colorWithRed:(0.0f/255.0f) green: (217.0f/255.0f) blue:(204.0f/255.0f) alpha:1.0f])

#define IS_BUTTON_INSETS UIEdgeInsetsMake(16, 26, 16, 26)

////////////////////////////////////////////////////////////////////////////////
// Useful function shortcuts
extern id interfaceIdiom(id iphone, id ipad);
extern BOOL isNilOrNull(id object);
extern BOOL isValid(id object);
extern BOOL hasTextualValue(NSString* string);
extern float getTotalDiskSpaceInBytes(void);
extern CGFloat systemVersion(void); // ignores minor revisions
extern NSString* generateUUID(void);
extern CGRect aspectFittedRect(CGRect inRect, CGRect maxRect);
//extern id SFJSONDecode(NSData *data, NSError **error); // not needed for iOS 5+

////////////////////////////////////////////////////////////////////////////////
// NSLog Variations

#ifdef __OBJC__

#if DEBUG == 1
// Run-Time Debug Output
#define DBLog(message, ...) \
NSLog((@"DEBUG: %s [Line %d] " message), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
#define DBTrace NSLog((@"TRACE: %s [Line %d]"), __PRETTY_FUNCTION__, __LINE__)

#else
// Define as nil
#define DBLog(message, ...) {}
#define DBTrace {}

#endif

// Run-time Error output
#define ERLog(message, ...) \
NSLog((@"ERROR: %s [Line %d] " message), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)


#endif /* OBJC */


////////////////////////////////////////////////////////////////////////////////
// Shortcuts for things I just *HATE* typing over & over & over.

#define AppDefaults     ([NSUserDefaults standardUserDefaults])

#define SYSTEM_VERSION                   [[[UIDevice currentDevice] systemVersion] floatValue]
#define SYSTEM_VERSION_EQUAL_TO(v)                  (SYSTEM_VERSION == v)
#define SYSTEM_VERSION_GREATER_THAN(v)              (SYSTEM_VERSION >  v)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  (SYSTEM_VERSION >= v)
#define SYSTEM_VERSION_LESS_THAN(v)                 (SYSTEM_VERSION <  v)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     (SYSTEM_VERSION <= v)

// Finer-grain control really isn't necessary.
#define iOS_5 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(5.0) 
#define iOS_43 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(4.3)
#define iOS_42  SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(4.2) /* Last iPhone 3G Version */
#define iOS_4 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(4.0)
#define iOS_32 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(3.2) /* First iPad Version */
#define iOS_3 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(3.0)

#define NSFORMAT(value, ...)    ([NSString stringWithFormat:value, ## __VA_ARGS__])
#define NSBOOL(value)           [NSNumber numberWithBool:value]
#define NSINT(value)            [NSNumber numberWithInt:value]
#define NSFLOAT(value)          [NSNumber numberWithDouble:value]
#define NSLONGLONG(value)       [NSNumber numberWithLongLong:value]

#define foy frame.origin.y
#define fox frame.origin.x
#define fsw frame.size.width
#define fsh frame.size.height

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define isPortrait(orientation) UIInterfaceOrientationIsPortrait(orientation)
#define isLandscape(orientation) UIInterfaceOrientationIsLandscape(orientation)

#define LocaleCode [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier]
#define LanguageCode [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]
#define CountryCode [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]
#define ExemplarCharacterSet [[NSLocale currentLocale] objectForKey:NSLocaleExemplarCharacterSet]

enum {
    tDouble = 0,
    tFloat,
    tInt,
    tLongLong,
    tBOOL,
    tNSInteger,
};
typedef NSInteger tNumberType;

// Some more shortcuts for quickly converting JSON values
@interface NSString (Number_Shortcut) 

- (NSNumber*) numberValue;
- (NSNumber*) numberValueWithType:(tNumberType)type;

@end

@interface UIDevice (machine_version)
- (BOOL) supportsCameraFocus;
- (NSString *)machine;
@end

#import "BlockActions.h"

@interface NSError (UserLogging)

- (void) log;
- (void) logDeep;

@end

@interface NSObject (PropertyListing)

// aps suffix to avoid namespace collsion
//   ...for Andrew Paul Sardone
- (NSDictionary *)properties_aps;

@end

