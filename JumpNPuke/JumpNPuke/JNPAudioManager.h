//
//  JNPAudioManager.h
//  PawAppsExample_SimpleAudioEngine
//
//  Created by Vincent on 27/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"
#import "CCNode.h"


@interface JNPAudioManager : CCNode {
	
}

-(void) playMusicWithStress:(int)stress;
-(void) playMusic:(int)stress;
-(void) stopMusic;
-(void) pauseMusic;
-(void) resumeMusic;
-(void) play:(NSString *)soundType;
-(void) preload;
-(void) playJump;
-(void) playPuke;
-(void) backgroundMusicTick:(float)dt;
-(void) playBGM;
+(JNPAudioManager *) sharedAM;

@property (nonatomic) int nextMusicStress;
@property (nonatomic) ALuint currentBGM;
@property (strong) NSMutableArray * soundFiles;
@property (strong) NSMutableArray * bgmFiles;

@end
