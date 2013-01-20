//
//  JNPGameLayer.h
//  Test22
//
//  Created by Vincent on 28/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "Box2DHelper.h"
//#import "GLES-Render.h"
#import "JNPAudioManager.h"
#import "JNPScore.h"
#import "MyContactListener.h"
#import "CCParallaxScrollNode.h"

#define KSIZESMALL 0.3
#define KSIZEBIG 0.6
#define KREBONDISSEMENT 0.55
#define KFRICTION 21


//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
//#define PTM_RATIO 32


@class JNPControlLayer;
@class JNPGameScene;

// JNPGameLayer
@interface JNPGameLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
//	GLESDebugDraw *m_debugDraw;		// strong ref
    
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
 
	JNPGameScene * gameScene;	
    MyContactListener *_contactListener;
    
    b2Body *playerBody;

    float prevPlayerPosition;
    float prevPlayerPosition_y;
    float currentSpeed;
	float currentScale;
	float elephantSize;
	float playerDensity;
	float bonusMalusIPhoneScale;
	float rayonItems;
	int forceFactor;
	int forceAccel;
	int currentMusicStress;
	BOOL hasWon;
	b2CircleShape * currentCircle;

    JNPAudioManager *_audioManager;
    CCParallaxScrollNode *parallax;

    
    NSMutableArray *lesBonusDeTaMere;
    NSMutableArray *lesObstaclesDeTonPere;
    NSMutableArray *lesVomisDeTaGrandMere;
}


-(void)setAudioManager:(JNPAudioManager *)audioM;
-(void)tellPlayerToJump;
-(void)tellPlayerToPuke:(CGPoint)position;
-(void)restorePlayerTexture:(float)dt;
-(void)diminuerPlayerDeltaScale:(float)deltaScale;
-(void)diminuerPlayerDeltaScale:(float)deltaScale withEffect:(Boolean)effect;
-(void)checkCollisions: (ccTime) dt;
-(void)initPhysics;
-(void)playerGrowWithBonus;
-(void)gameover;
-(void)setControlLayer:(JNPControlLayer *)c;
-(void)setGameScene:(JNPGameScene *)s;


@property (nonatomic, strong) CCTMXTiledMap *tileMap;
@property (nonatomic, strong) CCTMXLayer *background;
@property (nonatomic) b2Body *playerBody;



@end
