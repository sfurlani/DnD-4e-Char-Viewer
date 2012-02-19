//
//  SynthesizeSingleton.h
//  MyMovieMoments
//
//  Created by Stephen Furlani on 11/22/11.
//  Copyright (c) 2011 Accella, LLC. All rights reserved.
//

#ifndef SynthesizeSingleton_h
#define SynthesizeSingleton_h

#define SYNTHESIZE_SINGLETON_ARC(class) \
static class *shared##class = nil; \
 \
+ (id)shared##class { \
    @synchronized(self) { \
        if (shared##class == nil) \
            shared##class = [[self alloc] init]; \
            } \
    return shared##class; \
}


#define SYNTHESIZE_SINGLETON_NOARC(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
    @synchronized(self) \
    { \
        if (shared##classname == nil) \
        { \
            shared##classname = [[self alloc] init]; \
        } \
    } \
    \
    return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
    @synchronized(self) \
    { \
        if (shared##classname == nil) \
        { \
        shared##classname = [super allocWithZone:zone]; \
        return shared##classname; \
        } \
    } \
    \
    return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return self; \
} \
\
- (id)retain \
{ \
    return self; \
} \
\
- (NSUInteger)retainCount \
{ \
    return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
    return self; \
}


#endif
