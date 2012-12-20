//
//  JNPControlLayer.m
//  JumpNPuke
//
//  Created by Alain Vagner on 28/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "JNPControlLayer.h"

#import "JNPGameScene.h"

CCSprite * jumpButton;
CCSprite * pukeButton;
CGSize winSize;
id jumpButtonNormal;
id jumpButtonSelected;
id pukeButtonNormal;
id pukeButtonSelected;



@implementation JNPControlLayer


@synthesize rawAccelY;

- (id)init {
    self = [super init];
    if (self) {
		state = kPaddleStateUngrabbed;
		winSize = [[CCDirector sharedDirector] winSize];
		orientation = 1;
		
        
        
		jumpButton = [CCSprite spriteWithSpriteFrameName: @"jumpButton.png"];
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			jumpButton.position = ccp( 60, 60 );
		} else {
			jumpButton.position = ccp( 100, 100 );
		}
        [self addChild:jumpButton];

		
		pukeButton = [CCSprite spriteWithSpriteFrameName: @"pukeButton.png"];
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			pukeButton.position = ccp(winSize.width - 60, 60);
		} else {
			pukeButton.position = ccp(winSize.width - 100, 100);
		}
        [self addChild:pukeButton];	
		
        
		// Affichage du score
        JNPScore * s = [JNPScore sharedInstance];
        int t = [s getScore];
        t += 0;
        NSString * str = [NSString stringWithFormat:@"Score: %d", t];
        CGSize labelSize;
		CGPoint labelPos;
		int fontSize = 0;
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			labelSize.width = 200;
			labelSize.height= 25;
			fontSize = 21;
			labelPos = ccp(100, winSize.height - 20);
		} else {
			labelSize.width = 400;
			labelSize.height= 50;
			fontSize = 42;
			labelPos = ccp(213, winSize.height - 30);
		}

		
        labelScore = [CCLabelTTF labelWithString:str dimensions:labelSize hAlignment:kCCTextAlignmentLeft fontName:@"Chalkduster" fontSize:fontSize];
        [labelScore setColor:ccc3(240, 0, 0)];
        [labelScore setPosition: labelPos];
        labelShadowScore = [CCLabelTTF labelWithString:str dimensions:labelSize hAlignment:kCCTextAlignmentLeft fontName:@"Chalkduster" fontSize:fontSize];
        [labelShadowScore setColor:ccc3(0, 0, 0)];
        [labelShadowScore setPosition: ccp(labelPos.x+2, labelPos.y -1)];
        [self addChild: labelShadowScore];
        [self addChild: labelScore];
		
		
		int time = [s getTime];
        NSString * strTime = [NSString stringWithFormat:@"Time: %d", time];
        CGSize labelSizeTime;
		CGPoint labelPosTime;
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			labelSizeTime.width = 200;
			labelSizeTime.height= 25;
			labelPosTime = ccp(280, winSize.height - 20);
		} else {
			labelSizeTime.width = 400;
			labelSizeTime.height= 50;
			labelPosTime = ccp(600, winSize.height - 30);
		}

		labelTime = [CCLabelTTF labelWithString:strTime dimensions:labelSize hAlignment:kCCTextAlignmentLeft fontName:@"Chalkduster" fontSize:fontSize];
        [labelTime setColor:ccc3(240, 0, 0)];
        [labelTime setPosition: labelPosTime];
        labelShadowTime = [CCLabelTTF labelWithString:strTime dimensions:labelSize hAlignment:kCCTextAlignmentLeft fontName:@"Chalkduster" fontSize:fontSize];
        [labelShadowTime setColor:ccc3(0, 0, 0)];
        [labelShadowTime setPosition: ccp(labelPosTime.x+2, labelPosTime.y -1)];
        [self addChild: labelShadowTime];
        [self addChild: labelTime];		


		menuItemPause = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pause-off.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"pause-on.png"] target:self selector:@selector(menuPause)];

        CCMenu * myMenu2 = [CCMenu menuWithItems:menuItemPause, nil];
		
        [myMenu2 alignItemsHorizontally];
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			myMenu2.position = ccp(480-50, 320-30);
		} else {
			myMenu2.position = ccp(1024-100, 768-100);
		}
        [self addChild:myMenu2];
		
 
		// Initialisation de l'accelerometre
		
        self.isAccelerometerEnabled = YES;
        
		[self setRawAccelY:[NSMutableArray arrayWithCapacity:NUM_FILTER_POINTS]];
        for (int i = 0; i < NUM_FILTER_POINTS; i++)
        {
            [[self rawAccelY] addObject:[NSNumber numberWithFloat:0.0]];
        } 
		
        UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
        [accelerometer setUpdateInterval:1.0/15.0];
        // accelerometer.updateInterval = 1.0/60.0;
        // accelerometer.delegate = self;
        
        
		self.isTouchEnabled = NO;
	}
    return self;
}

-(void)setGameScene:(JNPGameScene *)s {
	gameScene = s;
}

-(void)disablePauseMenu
{
	[menuItemPause setIsEnabled:NO];
}

-(void)enablePauseMenu
{
	[menuItemPause setIsEnabled:YES];
}

- (void)showScore: (int)score {
    NSString * str = [NSString stringWithFormat:@"Score: %d", score];
    [labelShadowScore setString:str];
    [labelScore setString:str];
}

- (void)showTime: (int)t {
    NSString * str = [NSString stringWithFormat:@"Time: %d", t];
    [labelShadowTime setString:str];
    [labelTime setString:str];
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

- (float)getAccelY
{
    return accelY;
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{    
    [[self rawAccelY] insertObject:[NSNumber numberWithFloat: acceleration.y] atIndex:0];
    [[self rawAccelY] removeObjectAtIndex:NUM_FILTER_POINTS];
    
    // perform averaging
    accelY = 0.0;
    for (NSNumber *raw in [self rawAccelY])
    {
        accelY += [raw floatValue];
    }    
	UIInterfaceOrientation u= [[CCDirector sharedDirector] interfaceOrientation];
	if (u == UIInterfaceOrientationLandscapeLeft) {
		orientation = 1;
	} else if (u == UIInterfaceOrientationLandscapeRight) {
		orientation = -1;
	}

	accelY *= orientation;
	
    //NSLog(@"accel.y = %f - valeurmem = %f -- prout %f", accelY, [(NSNumber *)[[self rawAccelY] objectAtIndex:0] floatValue],acceleration.y);
    
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Désactivation temporaire du lock sur les boutons pour étudier le comportement (à cause du bug de blocage en mode jump)     
	// if (state != kPaddleStateUngrabbed) return NO;
	state = kPaddleStateGrabbed;
	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	if (!pause) {
		if (location.x < winSize.width /2) {
			[jumpButton setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
										 spriteFrameByName:@"jumpButton-selected.png"]];
			
			[ref tellPlayerToJump];
			
		} else {
			[pukeButton setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
										 spriteFrameByName:@"pukeButton-selected.png"]];
			
			[ref tellPlayerToPuke:location];
		}
	}
	
	return YES;
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Désactivation temporaire du lock sur les boutons pour étudier le comportement (à cause du bug de blocage en mode jump) 
	// NSAssert(state == kPaddleStateGrabbed, @"Paddle - Unexpected state!");
	state = kPaddleStateUngrabbed;
	if (!pause) {
		[jumpButton setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
									 spriteFrameByName:@"jumpButton.png"]];
		[pukeButton setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
									 spriteFrameByName:@"pukeButton.png"]];
	}
}

-(void)assignGameLayer:(JNPGameLayer *)gameLayer{
    ref=gameLayer;
}

-(void)menuPause {
	if (!pause) {
		self->pause = YES;
		JNPAudioManager *audioManager = [JNPAudioManager sharedAM];
		[audioManager play:jnpSndMenu];	
		[audioManager pauseMusic];
		//self.isTouchEnabled = NO; // empêche que les deux boutons soient encore actifs dans le menu pause

		[[CCDirector sharedDirector] pause];
		[gameScene showPauseLayer];
	}
	
}

-(void)resume {
	pause = NO;
	//self.isTouchEnabled = YES;
	//[self enablePauseMenu];
	[[JNPAudioManager sharedAM] resumeMusic];

	[[CCDirector sharedDirector] resume];
	[gameScene hidePauseLayer];
}

- (void) dealloc
{
	UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
	accelerometer.delegate = nil;		
	
}

@end
