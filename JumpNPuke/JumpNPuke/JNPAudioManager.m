//
//  JNPAudioManager.m
//  PawAppsExample_SimpleAudioEngine
//
//  Created by Vincent on 27/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPAudioManager.h"
#import "SimpleAudioEngine.h"
#import "CCNode.h"
#import "GCDSingleton.h"

@implementation JNPAudioManager
@synthesize counter;
@synthesize nextMusicStress;



#pragma mark Singleton

static JNPAudioManager *sharedAM = nil;


+ (JNPAudioManager *) sharedAM
{
	DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
		return [[self alloc] init];
	});
}


// Memory
- (void) dealloc
{
	sharedAM = nil;
}

+(void) end
{
	sharedAM = nil;
}



#pragma mark AudioManager

-(id) init
{
	if( (self=[super init])) {
        self.counter = 0;
        self.nextMusicStress = -1;
        // [self preload];
        [self schedule:@selector(backgroundMusicTick:) interval:0.83];
    }
   	return self;
}

// playMusic
-(void) playMusic:(int)stress {
    switch (stress) {
        case 1:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Theme1.aifc" loop:YES];
            break;
        case 2:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Theme2.aifc" loop:YES];
            break;
        case 3:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Theme3.aifc" loop:YES];
            break;
        case 4:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Theme4.aifc" loop:YES];
            break;
        default:
            break;
    }
}

// playNextMusic
-(void) playMusicWithStress:(int)stress {
    self.nextMusicStress = stress;
}

-(void) stopMusic {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void) pauseMusic {
	[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

-(void) resumeMusic {
	[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

-(void) playJump {
	int r = arc4random() % 3;
	r+=jnpSndJump1;
	[self play:r];
}

-(void) playPuke {
	int r = arc4random() % 5;
	r+=jnpSndPuke1;
	[self play:r];
}

// play
-(void) play:(int)soundType {
    switch (soundType) {
		case jnpSndNoSound:
			break;
		case jnpSndBile:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Bile.caf"];			
			break;
		case jnpSndMalus:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Bonus.caf"];			
			break;
		case jnpSndCollision:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Collision.caf"];		
			break;	
        case jnpSndDie:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Game_Over.caf"];
            break;	
        case jnpSndJump1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Jump1.caf"];
            break;
        case jnpSndJump2:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Jump2.caf"];
            break;	
        case jnpSndJump3:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Jump3.caf"];
            break;				
		case jnpSndLevel_Up:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Checkpoint.caf"];				
			break;
		case jnpSndBonus:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Malus.caf"];			
			break;
		case jnpSndMenu:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Menu.caf"];			
			break;		
		case jnpSndObstacle:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Obstacle.caf"];			
			break;
		case jnpSndPuke1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Puke1.caf"];			
			break;
		case jnpSndPuke2:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Puke2.caf"];			
			break;
		case jnpSndPuke3:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Puke3.caf"];			
			break;
		case jnpSndPuke4:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Puke4.caf"];			
			break;
		case jnpSndPuke5:
            [[SimpleAudioEngine sharedEngine] playEffect:@"Puke5.caf"];			
			break;
        default:
			NSLog(@"--Sound not found\n");
            break;
    }
}

// preload files
-(void) preload {
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Bile.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Bonus.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Collision.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Game_Over.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Jump1.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Jump2.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Jump3.caf"];	
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Checkpoint.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Malus.caf"];		
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Menu.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Obstacle.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Puke1.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Puke2.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Puke3.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Puke4.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Puke5.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Theme1.aifc"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Theme2.aifc"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Theme3.aifc"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Theme4.aifc"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Intro.aifc"];
}

// called every 0.5 sec
-(void) backgroundMusicTick:(ccTime)time {
    self.counter = self.counter + 1;
    
    if (self.nextMusicStress == -1 || (self.counter % 10 == 0 && self.nextMusicStress != 0)) {
        int stress = self.nextMusicStress;
        self.nextMusicStress = 0;
        [self playMusic:stress];
    }
}



@end
