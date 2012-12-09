//
//  JNPGameScene.h
//  JumpNPuke
//
//  Created by Alain Vagner on 15/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "JNPAudioManager.h"
#import "JNPPauseLayer.h"
#import "JNPControlLayer.h"
#import "JNPGameLayer.h"



@interface JNPGameScene : CCScene {	
	
}
@property (strong) JNPControlLayer * controlLayer;
@property (strong) JNPGameLayer * gameLayer;
@property (strong) JNPPauseLayer * pauseLayer;
@property (strong) CCParallaxScrollNode * parallax;

-(void)showPauseLayer;
-(void)hidePauseLayer;


@end
