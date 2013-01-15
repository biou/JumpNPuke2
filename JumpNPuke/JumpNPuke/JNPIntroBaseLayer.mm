//
//  JNPGameLayer.m
//  plop
//
//  Created by Alain Vagner on 04/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "JNPIntroBaseLayer.h"



// IntroBaseLayer implementation
@implementation JNPIntroBaseLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	

	JNPIntroBaseLayer * baseLayer = [JNPIntroBaseLayer node];
	
	[scene addChild: baseLayer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		JNPAudioManager *am = [JNPAudioManager sharedAM];
		[am preload];

		// initialisation de textures
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ingame.plist"];
		
    }
    return self;
}

-(void) onEnter
{
	[super onEnter];

	// logo qui va s'animer
	CCSprite *logo = Nil;
	CGSize winsize = [[CCDirector sharedDirector] winSize];
	if (568.0 - winsize.width <1 ) {
		logo = [CCSprite spriteWithFile:@"intro-i5.png"];
	} else {
		logo = [CCSprite spriteWithFile:@"intro.png"];
	}
	
	// fond d'écran
	
	//logo.position = ccp(winsize.width/2 , winsize.height+(457/2) );
	logo.position = ccp(winsize.width/2 , winsize.height/2 );
	[self addChild:logo];

	
	// Pour éviter de saccader l'animation lors du chargement du son, on préload le son maintenant et on le schedule quand on veut.
	// Aussi, on unload le son dans la méthode dealloc (j'imagine
	// à noter également qu'il faut éviter les sons en wav et qu'il est facile de convertir en .caf… j'amènerai un script pour faire cette
	// conversion tt seule
	[self scheduleOnce:@selector(introSound:) delay:0.65];
	[self scheduleOnce:@selector(toNextScene:) delay:3.8];
}

- (void) toNextScene:(ccTime) dt {
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.75f scene:[JNPMenuBaseLayer scene]]];
}

- (void) introSound:(ccTime) dt {
    JNPAudioManager *am = [JNPAudioManager sharedAM];
	[am play:jnpSndLevel_Up];
}



@end
