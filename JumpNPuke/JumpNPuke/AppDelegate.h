//
//  AppDelegate.h
//  JumpNPuke
//
//  Created by Biou on 14/10/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "JNPIntroBaseLayer.h"
#import "GCHelper.h"
#import "TestFlight.h"

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;
	
	CCDirectorIOS	*__weak director_;							// weak ref
    JNPIntroBaseLayer *introLayer;
	NSOperationQueue *queue;
}

@property (nonatomic, strong) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, strong) NSOperationQueue *queue;

@end
