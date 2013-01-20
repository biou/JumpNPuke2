//
//  JNPGameScene.mm
//  JumpNPuke
//
//  Created by Alain Vagner on 15/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPGameScene.h"


@implementation JNPGameScene

@synthesize controlLayer;
@synthesize gameLayer;
@synthesize pauseLayer;
@synthesize parallax;

- (id)init {
    self = [super init];
    if (self) {
	
		//pauseLayer = [JNPPauseLayer node];
		gameLayer = [JNPGameLayer node];
		controlLayer = [JNPControlLayer node];
		[controlLayer assignGameLayer:gameLayer];


        /**** parallax ****/
        parallax = [CCParallaxScrollNode node];
        CCSprite *clouds1 = [CCSprite spriteWithFile:@"paralaxe1.png"];
        CCSprite *clouds2 = [CCSprite spriteWithFile:@"paralaxe2.png"];
        CCSprite *clouds1bis = [CCSprite spriteWithFile:@"paralaxe1.png"];
        CCSprite *clouds2bis = [CCSprite spriteWithFile:@"paralaxe2.png"];
        float totalWidth = 2 * clouds1.contentSize.width; // taille en points
		//NSLog(@"width p1 %f", clouds1.contentSize.width);
        [parallax addChild:clouds1 z:0 Ratio:ccp(1.3,1) Pos:ccp(0,0) ScrollOffset:ccp(totalWidth,0)];
        [parallax addChild:clouds2 z:0 Ratio:ccp(0.6,1) Pos:ccp(0,0) ScrollOffset:ccp(totalWidth,0)];
        
		//[parallax addInfiniteScrollXWithZ:0 Ratio:ccp(1.3,1) Pos:ccp(0,0) Objects:clouds1, clouds1bis, nil];
		//[parallax addInfiniteScrollXWithZ:0 Ratio:ccp(0.6,1) Pos:ccp(0,0) Objects:clouds2, clouds2bis, nil];
		[parallax addChild:clouds1bis z:0 Ratio:ccp(1.3,1) Pos:ccp(clouds1.contentSize.width,0) ScrollOffset:ccp(totalWidth,0)];
        [parallax addChild:clouds2bis z:0 Ratio:ccp(0.6,1) Pos:ccp(clouds2.contentSize.width,0) ScrollOffset:ccp(totalWidth,0)];
        // Add to layer, sprite, etc.
        [self addChild:parallax z:-1];	
		
		[gameLayer setGameScene:self];
		[controlLayer setGameScene:self];
		//[pauseLayer setControlLayer:controlLayer];
		
		
		
		CCLayer *bgLayer = [CCLayer node];
		CGSize s = [CCDirector sharedDirector].winSize;		
		// init du background
		CGSize winsize = [[CCDirector sharedDirector] winSize];
		CCSprite *bgpic = Nil;
		if (fabs(568.0 - winsize.width) <1 ) {
			bgpic = [CCSprite spriteWithFile:@"fondpapier-i5.png"];
		} else {
			bgpic = [CCSprite spriteWithFile:@"fondpapier.png"];
		}
		
		bgpic.position = ccp(bgpic.position.x + s.width/2.0, bgpic.position.y+s.height/2.0);
		//bgpic.opacity = 160;
		bgpic.color = ccc3(160, 160, 160);
		[bgLayer addChild:bgpic];
		[self addChild:bgLayer z:-10];

		
		
		JNPAudioManager *audioManager = [JNPAudioManager sharedAM];
		[audioManager playMusic:1];
		[gameLayer setAudioManager:audioManager];
		
		// add layer as a child to scene
		//[self addChild: pauseLayer z:-15 tag:3];
		[self addChild: gameLayer z:5 tag:1];
		[self addChild: controlLayer z:10 tag:2];

    }
    return self;
}

-(void)showPauseLayer
{
	pauseLayer = [JNPPauseLayer node];
	[pauseLayer setControlLayer:controlLayer];
	[self addChild: pauseLayer z:15 tag:3];
	
	//[self reorderChild:pauseLayer z:15];
	
	//pauseLayer.isTouchEnabled=YES;
	// enable touch on it
	//[[[CCDirector sharedDirector] touchDispatcher] setPriority:-15 forDelegate:pauseLayer];
}


-(void)hidePauseLayer
{
	[self removeChild:pauseLayer cleanup:YES];
	//[self removeChild:pauseLayer cleanup:NO];
	//[self reorderChild:pauseLayer z:-15];
	//pauseLayer.isTouchEnabled=NO;
	// disable touch on it
	//[[[CCDirector sharedDirector] touchDispatcher] setPriority:15 forDelegate:pauseLayer];
}

@end
