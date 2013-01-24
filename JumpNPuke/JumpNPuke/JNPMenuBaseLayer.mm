//
//  MenuBaseLayer.m
//  plop
//
//  Created by Alain Vagner on 22/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPMenuBaseLayer.h"


JNPAudioManager * audioManager;
CCMenu * myMenu;

@implementation JNPMenuBaseLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	
	JNPMenuBaseLayer * baseLayer = [[JNPMenuBaseLayer alloc] init];
	
	[scene addChild: baseLayer];
	
	// return the scene
	return scene;
}

- (id)init {
    self = [super init];
    if (self) {
		[[JNPAudioManager sharedAM] nextBGMWithName:@"Intro.aifc"];
		[[JNPAudioManager sharedAM] playBGMWithName:@"Intro.aifc"];		
		[self schedule:@selector(bgmUpdate:) interval:19.3];
		CGSize winsize = [[CCDirector sharedDirector] winSize];
		
		CCSprite * logo = Nil;
		//NSLog(@"Winsize: %f", winsize.width);
		if (fabs(568.0 - winsize.width) < 1.0) {
			logo = [CCSprite spriteWithFile: @"fond-menu-i5.png"];
			//NSLog(@"i5");
		} else {
			logo = [CCSprite spriteWithFile: @"fond-menu.png"];
			//NSLog(@"hd");
		}
        

        logo.position = ccp(winsize.width/2 , winsize.height/2 );
		[self addChild:logo z:0];	
		
		[[GCHelper sharedInstance] setAuthChangeDelegate:self];
		
		// http://www.cocos2d-iphone.org/wiki/doku.php/prog_guide:lesson_3._menus_and_scenes
        
		[self setupMenu];
		
		CCMenuItemImage *menuItem3 = [CCMenuItemImage itemWithNormalImage:@"help.png"
															selectedImage: @"help-on.png"
																   target:self
																 selector:@selector(menu3)];
        
        CCMenu * myMenu2 = [CCMenu menuWithItems:menuItem3, nil];

        [myMenu2 alignItemsHorizontally];
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
				myMenu2.position = ccp(27, 55);
		} else {
				myMenu2.position = ccp(70, 113);
		}

		[self addChild:myMenu2];
        
        
		// increment level
		JNPScore * sc = [JNPScore sharedInstance];
		[sc setLevel:1];
		[sc setScore:0];
		[sc setTime:90];		
		
        // Il ne sert à rien d'activer le "Touch" sur ce Layer car le menu, lui, est TouchEnabled.
        // self.isTouchEnabled = YES;		
    }
    return self;
}

- (void) dealloc
{
	[[GCHelper sharedInstance] setAuthChangeDelegate:nil];
	
}


-(void)setupMenu {
	if (myMenu != nil) {
		[self removeChild:myMenu cleanup:NO];
	}

	CGSize winsize = [[CCDirector sharedDirector] winSize];

	CCMenuItemImage *menuItem1 = [CCMenuItemImage itemWithNormalImage:@"start-over.png"
														selectedImage: @"start.png"
															   target:self
															 selector:@selector(menu1)];
	CCMenuItemImage *menuItem2 = [CCMenuItemImage itemWithNormalImage:@"credits.png"
														selectedImage: @"credits-over.png"
															   target:self
															 selector:@selector(menu2)];
	
	CCMenuItemImage *menuItem4 = [CCMenuItemImage itemWithNormalImage:@"scores.png"
														selectedImage: @"scores-over.png"
															   target:self
															 selector:@selector(menu4)];
	
	
	myMenu = [CCMenu menuWithItems:menuItem1, nil];
	BOOL userAuth = [[GCHelper sharedInstance] isUserAuthenticated];
	if (userAuth) {
		NSLog(@"user authenticated, we add the menu item\n");
		[myMenu addChild:menuItem4];
	}
	[myMenu addChild:menuItem2];
	
	// Arrange the menu items vertically
	[myMenu alignItemsVertically];
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		myMenu.position = ccp(winsize.width/2, 125);
	} else {
		myMenu.position = ccp(winsize.width/2, 280);
	}

	// add the menu to your scene
	[self addChild:myMenu];
	
	
}

-(void)menu1 {
	[self startMenuAction];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[JNPGameScene node]]];
    
}

-(void)menu2 {
	[self startMenuAction];	
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: [JNPBasicLayer scene:jnpCredits]]];    
}

-(void)menu3 {
	[self startMenuAction];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: [JNPBasicLayer scene:jnpHelp]]];    
}

-(void)menu4 {
	[self startMenuAction];
	[[GCHelper sharedInstance] displayLeaderboard];
}

-(void)startMenuAction {
	[self unscheduleAllSelectors];
	[self unscheduleUpdate];
	JNPAudioManager *audioManager = [JNPAudioManager sharedAM];
	[audioManager playSFX:@"Menu.caf"];
	[audioManager stopBGM];
}

-(void)handleAuthChange:(BOOL) n {
	[self setupMenu];
}

- (void) bgmUpdate:(ccTime) dt {
	JNPAudioManager *audioManager = [JNPAudioManager sharedAM];
	[audioManager bgmTick:dt];
}

@end
