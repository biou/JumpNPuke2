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

#pragma mark Singleton

static JNPAudioManager *sharedAM = nil;


+ (JNPAudioManager *) sharedAM
{
	DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
		return sharedAM = [[self alloc] init];
	});
}


#pragma mark AudioManager

-(id) init
{
	if( (self=[super init])) {
        self.nextMusicStress = 1;

		NSArray * caf = [[NSBundle mainBundle] pathsForResourcesOfType:@".caf" inDirectory:@"."];
		self.soundFiles = [NSMutableArray arrayWithCapacity:[caf count]];
		for (NSString * s in caf) {
			[self.soundFiles addObject:[s lastPathComponent]];
		}
		NSArray * aifc = [[NSBundle mainBundle] pathsForResourcesOfType:@".aifc" inDirectory:@"."];
		self.bgmFiles = [NSMutableArray arrayWithCapacity:[aifc count]];
		for (NSString * s in aifc) {
			[self.bgmFiles addObject:[s lastPathComponent]];
		}
		[[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:self selector:@selector(backgroundMusicFinished)]; 
    }
   	return self;
}

// playMusic
-(void) playMusic:(int)stress {
	if (stress < [self.bgmFiles count]) {
		self.currentBGM = [[SimpleAudioEngine sharedEngine] playEffect:[self.bgmFiles objectAtIndex:stress]];
	}
}

// playNextMusic
-(void) playMusicWithStress:(int)stress {
    self.nextMusicStress = stress;
	//NSLog(@"stress: %d", stress);
}

-(void) stopMusic {
    //[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[[SimpleAudioEngine sharedEngine] stopEffect:self.currentBGM];
}

-(void) pauseMusic {
	//[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	[[SimpleAudioEngine sharedEngine] stopEffect:self.currentBGM];
}

-(void) resumeMusic {
	//[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
	[self playMusic:self.nextMusicStress];
}

-(void) playJump {
	int r = (arc4random() % 2) +1;
	[self play:[NSString stringWithFormat:@"Jump%d.caf",r]];
}

-(void) playPuke {
	
	int r = (arc4random() % 5)+1;
	[self play:[NSString stringWithFormat:@"Puke%d.caf",r]];
}

// play
-(void) play:(NSString *)soundType {
	if (![soundType isEqual:@""]) {
		if ([self.soundFiles containsObject:soundType]) {
			[[SimpleAudioEngine sharedEngine] playEffect:soundType];
		} else {
			NSLog(@"--Sound not found:%@", soundType);
		}
	}

}

// preload files
-(void) preload {
	for (NSString* s in self.soundFiles) {
		[[SimpleAudioEngine sharedEngine] preloadEffect:s];
	}
	for (NSString* s in self.bgmFiles) {
		[[SimpleAudioEngine sharedEngine] preloadEffect:s];
	}
}

-(void)backgroundMusicTick:(float)dt {
	//NSLog(@"background music tick");
	[self playMusic:self.nextMusicStress];
}

-(void)playBGM {
	[self backgroundMusicTick:0.0];

}



@end
