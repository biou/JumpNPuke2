//
//  JNPDeath.mm
//  JumpNPuke
//
//  Created by Alain Vagner on 28/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPBasicLayer.h"


static int mode;

@implementation JNPBasicLayer

+(CCScene *) scene:(int) m
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	mode = m;
	JNPBasicLayer * baseLayer = [[JNPBasicLayer alloc] init];

	[scene addChild: baseLayer];
	
	// return the scene
	return scene;
}


- (id)init {
    self = [super init];
    if (self) {
		// init du background
		NSString * image;
		int son;
		switch (mode) {
			case jnpGameover:
				image = @"gameover.png";
				son = jnpSndDie;
				break;
			case jnpCredits:
				image = @"creditsImg.png";
				son = jnpSndNoSound;
				break;
			case jnpNewLevel:
				image = @"levelup.png";
				son = jnpSndLevel_Up;
				break;
			case jnpHelp:
				image = @"faq.png";
				son = jnpSndNoSound;
				break;				
			default:
				break;
		}

		CGSize winsize = [[CCDirector sharedDirector] winSize];		
		CCSprite *bgpic = Nil;
		if (mode == jnpHelp && fabs(568.0 - winsize.width <1 )) {
			bgpic = [CCSprite spriteWithFile:@"faq-i5.png"];
		} else if (mode == jnpCredits && fabs(568.0 - winsize.width <1 )) {
			bgpic = [CCSprite spriteWithFile:@"creditsImg-i5.png"];			
		} else {
			bgpic = [CCSprite spriteWithFile:image];
		}
		

        bgpic.position = ccp(winsize.width/2 , winsize.height/2 );
		[self addChild:bgpic];
		
		
		if (mode == jnpGameover) {
			JNPScore * s = [JNPScore sharedInstance];
			int t = [s getScore];
			s.vomis = [NSMutableArray array];
			[[GCHelper sharedInstance] reportScore:t forCategory:@"JNPScore1"];			
		}
		
		if (mode != jnpCredits && mode != jnpHelp)
		{
			JNPScore * s = [JNPScore sharedInstance];
			int newScore = [s getScore] + [s getTime]*100;
			NSString * str = nil;
			int fontSize = 0;
			CGPoint labelPos;

			if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
				fontSize = 21;
				labelPos = ccp(winsize.width/2, winsize.height-20);
			} else {
				fontSize = 42;
				labelPos = ccp(winsize.width/2, winsize.height-50);
			}
			
			if (mode == jnpGameover) {
				str = [NSString stringWithFormat:@"Score: %d", [s getScore]];
			} else {
				str = [NSString stringWithFormat:@"Score: %d + %d x 100 = %d", [s getScore], [s getTime], newScore];
				[s setScore:newScore];			
			}
			CCLabelTTF *label = [CCLabelTTF labelWithString:str fontName:@"Chalkduster" fontSize:fontSize];
			[label setPosition: labelPos];
			[self addChild: label];
		}
		
		if (mode == jnpNewLevel)
		{
			JNPScore * s = [JNPScore sharedInstance];
			[s incrementLevel];
			int t = [s getLevel];
			[s setTime:90];
			int fontSize = 0;
			CGPoint labelPos;
			
			if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
				fontSize = 32;
				labelPos = ccp(winsize.width/2, 20);
			} else {
				fontSize = 64;
				labelPos = ccp(winsize.width/2, 50);
			}
			NSString * str = [NSString stringWithFormat:@"Level %d", t]; 
			CCLabelTTF *label = [CCLabelTTF labelWithString:str fontName:@"Chalkduster" fontSize:fontSize];
			[label setPosition: labelPos];
			[self addChild: label];
		}
		

		
		
		
		
        JNPAudioManager *audioManager = [JNPAudioManager sharedAM];
        [audioManager stopMusic];
		[audioManager play:son];
		self.isTouchEnabled = YES;

    }
    return self;
}

- (void)onEnter
{
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director touchDispatcher] removeDelegate:self];
	[super onExit];
}



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	switch (mode) {
		case jnpGameover:
			[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[JNPMenuBaseLayer scene]]];
			break;
		case jnpCredits:
			[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[JNPMenuBaseLayer scene]]];
			break;
		case jnpHelp:
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[JNPGameScene node]]];
			break;
		case jnpNewLevel:
			[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[JNPGameScene node]]];
			break;				
		default:
			break;
	}

	

}


@end
