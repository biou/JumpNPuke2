//
//  GCDSingleton.h
//  JumpNPuke
//
//  Created by Biou on 24/11/12.
//  A macro for implementing singletons compatible with ARC
//

#ifndef JumpNPuke_GCDSingleton_h
#define JumpNPuke_GCDSingleton_h

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

#endif
