//
//  JNPGameLayer.mm
//  Test22
//
//  Created by Vincent on 28/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// Import the interfaces
#import "JNPGameLayer.h"

#import "JNPControlLayer.h"
#import "JNPBasicLayer.h"
#import "AppDelegate.h"

/*
enum {
	kTagParentNode = 1,
};
*/


#pragma mark JNPGameLayer
#pragma mark -

//id elephantNormalTexture,elephantPukeTexture, elephantJumpTexture;


// ta mère, elle mange des pruneaux !!!

@implementation JNPGameLayer

JNPControlLayer * controlLayer;


#pragma mark -
#pragma mark Création du Layer

-(id) init
{
	if( (self=[super init])) {
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CGSize ps = [[CCDirector sharedDirector] winSizeInPixels];
		
		hasWon = NO;
		bonusMalusIPhoneScale = 1.2;
		currentMusicStress = 1;
       
		// init de la Map avant box2d
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map.tmx"];
        //self.background = [_tileMap layerNamed:@"background"];
		[self addChild:_tileMap z:0];
        
        // obtention des positions potentielles de super bonus ta mère
        CCTMXObjectGroup *bonusGroup = [_tileMap objectGroupNamed:@"bonus"];
        NSMutableArray *tableauObjets = [bonusGroup objects];
        int nomber = [tableauObjets count];
        
        
        // initiailisation des bonus collectables
        lesBonusDeTaMere = [NSMutableArray array];

        JNPScore *s = [JNPScore sharedInstance];
        NSMutableArray *tmpVomis = s.vomis;
        
        // s'il y a trop de vomi, on en supprime jusqu'à ce qu'il ne reste plus que 20 vomis
        if ([tmpVomis count]>20) {
            while ([tmpVomis count]>20) {
                [tmpVomis removeObjectAtIndex:(arc4random()%[tmpVomis count])];
            }
        }
        
        int inheritedVomiCounter = 0;
        for (CCSprite *sprout in tmpVomis) {
            inheritedVomiCounter++;
			sprout.parent = nil;
            [self addChild:sprout];
            [lesBonusDeTaMere addObject:sprout];
        }
        
        // S'il y a moins de 12 vomis, on ajoute des bonus aléatoirement sur la map parmis de positions prévues;
        int maxBonus = 12;
        maxBonus -= inheritedVomiCounter;
        
		
        // grande cagnotte tirage au sort parmis les positions possibles de bonus, pour obtenir un tableau de quelques points différents sur lesquels placer des cadeaux bonux
        NSMutableArray *electedBonusPositionsInMap = [NSMutableArray arrayWithCapacity:12];
        if (maxBonus>0) {
            for (int ii=0; ii<maxBonus; ii++) {
                int kk = arc4random() % nomber;
                [electedBonusPositionsInMap insertObject:[tableauObjets objectAtIndex:kk] atIndex:ii];
                [tableauObjets removeObjectAtIndex:kk];
                nomber--;
            }
            
            // après le tirage au sort des positions, on y ajoute des sprites de bonus avec des images originales et également tirées au hasard! youpi super hahaha huhuhu hihihi
            for (NSMutableDictionary *nodule in electedBonusPositionsInMap) {
                CGPoint dasPunkt = ccp([[nodule valueForKey:@"x"] floatValue], [[nodule valueForKey:@"y"] floatValue]- ps.height + winSize.height);
                CCSprite *newCollectibleBonusYoupiTralalaPouetPouet = [CCSprite spriteWithSpriteFrameName:[@"bonus_0" stringByAppendingFormat:@"%d.png",arc4random()%6+2]];
                newCollectibleBonusYoupiTralalaPouetPouet.position=dasPunkt;
				if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
					newCollectibleBonusYoupiTralalaPouetPouet.scale = bonusMalusIPhoneScale;
				}
                [self addChild:newCollectibleBonusYoupiTralalaPouetPouet];
                rayonItems = newCollectibleBonusYoupiTralalaPouetPouet.contentSize.width;
                [lesBonusDeTaMere addObject:newCollectibleBonusYoupiTralalaPouetPouet];
            }
			rayonItems = rayonItems /2;
            
        }
        
        // initialisation des vomis de ta grand mere
        lesVomisDeTaGrandMere = [NSMutableArray array];

        
        // obtention des positions potentielles de super bonus ta mère
        CCTMXObjectGroup *obstaclesGroup = [_tileMap objectGroupNamed:@"obstacles"];
        NSMutableArray *tableauObstacles = [obstaclesGroup objects];
        nomber = [tableauObstacles count];
        
        // grande cagnotte tirage au sort parmis les positions possibles d'obstacles, pour obtenir un tableau de quelques points différents sur lesquels placer des badboys
        NSMutableArray *electedObstaclesPositionsInMap = [NSMutableArray arrayWithCapacity:9];
        lesObstaclesDeTonPere = [NSMutableArray arrayWithCapacity:9];
        for (int ii=0; ii<9; ii++) {
            int kk = arc4random() % nomber;
            [electedObstaclesPositionsInMap insertObject:[tableauObstacles objectAtIndex:kk] atIndex:ii];
            [tableauObstacles removeObjectAtIndex:kk];
            nomber--;
        }
        
        // après le tirage au sort des positions, on y ajoute des sprites de méchants connards avec des images originales et également tirées au hasard! youpi super hahaha huhuhu hihihi
        for (NSMutableDictionary *nodule in electedObstaclesPositionsInMap) {
            CGPoint dasPunkt = ccp([[nodule valueForKey:@"x"] floatValue], [[nodule valueForKey:@"y"] floatValue] - ps.height + winSize.height);
            CCSprite *newCollidableBadBoyYoupiTralalaPouetPouet = [CCSprite spriteWithSpriteFrameName:[@"ennemis_0" stringByAppendingFormat:@"%d.png",arc4random()%7+1]];
            newCollidableBadBoyYoupiTralalaPouetPouet.position=dasPunkt;
			if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
				newCollidableBadBoyYoupiTralalaPouetPouet.scale = bonusMalusIPhoneScale;
			}
            [self addChild:newCollidableBadBoyYoupiTralalaPouetPouet];
            [lesObstaclesDeTonPere addObject:newCollidableBadBoyYoupiTralalaPouetPouet];
        }
        
        
		// enable events
		
		self.isTouchEnabled = NO;
		
		// init physics
		[self initPhysics];
     
		// ajout de la tete de serpent
		// il est 5h23, je fais ce que je veux !
		// FIXME à ajuster
        CCSprite *serpent = [CCSprite spriteWithSpriteFrameName:@"serpent.png"];
        serpent.position=ccp([self limitLevelUp]-192.0*CC_CONTENT_SCALE_FACTOR(), winSize.height/2);
        [self addChild:serpent z:10];		
		

#pragma mark création du personnage
        // Create ball body and shape
        CCSprite *playerSprite = [CCSprite spriteWithSpriteFrameName:@"elephant-normal.png"];
        
		// taille en pixels de l'éléphant : 260px sur ipad

		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			if( CC_CONTENT_SCALE_FACTOR() == 2 ) {
				elephantSize = 520.0;
			} else {
				elephantSize = 260.0;
			}
			playerSprite.position=ccp(400, 768/2);
		} else {
			if( CC_CONTENT_SCALE_FACTOR() == 2 ) {
				elephantSize = 216.0;
			} else {
				elephantSize = 108.0;
			}
			playerSprite.position=ccp(200, 200);
		}
		NSLog(@"elephantsize: %f", elephantSize);
		forceAccel = 300;
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			if( CC_CONTENT_SCALE_FACTOR() == 2 ) { // ipad retina
				playerDensity = 0.5;
				forceFactor = 1;
			} else { // ipad
				playerDensity = 0.5;
				forceFactor = 1;
			}
		} else {
			if( CC_CONTENT_SCALE_FACTOR() == 2 ) { // iphone retina
				playerDensity = 8.0;
				forceFactor = 7;
				forceAccel = 600;
			} else { // iphone
				playerDensity = 10.0;
				forceFactor = 6;
			}
		}
		
		
		currentScale = 0.4;
		playerSprite.scale=currentScale;
		
        [self addChild:playerSprite];
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(playerSprite.position.x/[Box2DHelper pointsToMeterRatio], playerSprite.position.y/[Box2DHelper pointsToMeterRatio]);
        ballBodyDef.userData = (__bridge void *) playerSprite;
        playerBody = world->CreateBody(&ballBodyDef);
        playerBody->SetUserData((__bridge void *)playerSprite);
        //[self.sprite setPhysicsBody:body];
        
        b2CircleShape circle;
        circle.m_radius = elephantSize*playerSprite.scale/2/[Box2DHelper pixelsToMeterRatio];
		//NSLog(@"circle radius:%f", circle.m_radius);
        currentCircle = &circle;
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = playerDensity/currentScale;
		ballShapeDef.friction = KFRICTION;
        ballShapeDef.restitution = KREBONDISSEMENT;
        playerBody->CreateFixture(&ballShapeDef);
        [self schedule:@selector(updatePlayerPosFromPhysics:)];
		[self schedule:@selector(updatePlayerSize:) interval:0.3];
        [self schedule:@selector(updateViewPoint:)];
        [self schedule:@selector(detectBonusPickup:)];
        [self schedule:@selector(updateTime:) interval:1];
        [self schedule:@selector(detectObstacleCollision:)];
		
        [self scheduleUpdate];
	}
	return self;
}

-(void)setControlLayer:(JNPControlLayer *)c {
	controlLayer = c;
}

-(void)setParallax:(CCParallaxScrollNode *)p {
	parallax = p;
}

-(void)setGameScene:(JNPGameScene *)s {
	gameScene = s;
	[self setControlLayer:[gameScene controlLayer]];
	[self setParallax:[gameScene parallax]];
}

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	CGSize ps = [[CCDirector sharedDirector] winSizeInPixels];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -30.0f);
	
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
//	m_debugDraw = new GLESDebugDraw( [Box2DHelper pointsToMeterRatio] );
//	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
//	m_debugDraw->SetFlags(flags);
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
    
    /*****************************************************************/
    
	CCTMXObjectGroup *objects = [_tileMap objectGroupNamed:@"box"];
	NSMutableDictionary * objPoint;
    
	int x, y;

	for (objPoint in [objects objects]) {
        x = [[objPoint valueForKey:@"x"] intValue];
		y = [[objPoint valueForKey:@"y"] intValue];
		// cocos2d bug? or feature ? the coords returned by y does not correspond to what is in the tmx file
		// in fact y = ps.height - y
		y = ps.height - y;
        
        NSString *poly = [objPoint objectForKey:@"polylinePoints"];
        NSArray *points = [poly componentsSeparatedByString:@" "];
        
        NSString *p1s = [points objectAtIndex:0];
        NSArray *p1 = [p1s componentsSeparatedByString:@","];
        float p1x = (x + [[p1 objectAtIndex:0] floatValue]);
        float p1y = s.height - (y + [[p1 objectAtIndex:1] floatValue]);
        
		
        NSString *p2s = [points objectAtIndex:1];
        NSArray *p2 = [p2s componentsSeparatedByString:@","];
        float p2x = ([[p2 objectAtIndex:0] floatValue] + x);
        float p2y = s.height - (y + [[p2 objectAtIndex:1] floatValue]);

		//NSLog(@"polyline: %f, %f, %f, %f", p1x, p1y, p2x, p2y);
		
		p1x /= [Box2DHelper pointsToMeterRatio];
		p1y /= [Box2DHelper pointsToMeterRatio];
		p2x /= [Box2DHelper pointsToMeterRatio];
		p2y /= [Box2DHelper pointsToMeterRatio];
		
		//NSLog(@"polyline: %f, %f, %f, %f", p1x, p1y, p2x, p2y);

        groundBox.Set(b2Vec2(p1x, p1y), b2Vec2(p2x,p2y));
        groundBody->CreateFixture(&groundBox,0);
        
        
    }

	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/[Box2DHelper pointsToMeterRatio],0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/[Box2DHelper pointsToMeterRatio]), b2Vec2(s.width/[Box2DHelper pointsToMeterRatio],s.height/[Box2DHelper pointsToMeterRatio]));
	groundBody->CreateFixture(&groundBox,0);
    
    /*****************************************************************/
    // Create contact listener
    _contactListener = new MyContactListener();
    world->SetContactListener(_contactListener);
    
    
}

-(void)setAudioManager:(JNPAudioManager *)audioM {
    _audioManager = audioM;
}




#pragma mark Méthodes schedulées dans l'init

-(void)updateTime:(float)dt
{
	JNPScore * s = [JNPScore sharedInstance];
	[s decrementTime];
    [controlLayer showTime:[s getTime]];
}

-(void)updatePlayerSize:(float)dt {
	if (fabs(currentScale) > 0.08) {
        [self diminuerPlayerDeltaScale:0.002 withEffect:NO];
		
	} else {
		currentScale = 0.0;
		[self gameover];
		
	}
	
}

// Détection du ramassage des bonus par parcours de la liste des bonus présents dans le level et calcul de la distance entre le joueur et le bonus.
-(void)detectBonusPickup:(float)dt {
    
    // Pour chaque bonus existant
    for (CCSprite *schpritz in lesBonusDeTaMere) {
        
        // Calcul des distances
        CGPoint bonusPosition = schpritz.position;
        CGPoint playeurPosition = ((__bridge CCSprite *)playerBody->GetUserData()).position;
        CGPoint soubstraction = ccpSub(bonusPosition, playeurPosition);
        float distanceCarree = soubstraction.x * soubstraction.x + soubstraction.y * soubstraction.y;
        float dist = sqrtf(distanceCarree);
        float contentSize = ((__bridge CCSprite *)playerBody->GetUserData()).contentSize.width*((__bridge CCSprite *)playerBody->GetUserData()).scale;
        
        // Condition de ramassage du bonus. Le contenu du "if" est l'action en cas de ramassage
        if (dist < contentSize/2 + rayonItems) {
            
            // Suppression du bonus de la carte et de la liste des bonus
            [self removeChild:schpritz cleanup:NO];
            [lesBonusDeTaMere removeObject:schpritz];
            
            // Action sur le sprite du joueur
            [self playerGrowWithBonus];
            
            // Action sur le score
			JNPScore * s = [JNPScore sharedInstance];
			[s incrementScore:500];
            [controlLayer showScore:[s getScore]];
            
            // Son de ramassage du bonus
            [_audioManager play:@"Malus.caf"];
            return;
        }
    }
}


// Détection du ramassage d'un obstacle par parcours de la liste des obstacles présents dans le level et calcul de la distance entre le joueur et l'item. Code identique au bonus juste au dessus.
-(void)detectObstacleCollision:(float)dt {
    for (CCSprite *schpritz in lesObstaclesDeTonPere) {
        CGPoint obstaclePosition = schpritz.position;
        CGPoint playeurPosition = ((__bridge CCSprite *)playerBody->GetUserData()).position;
        CGPoint soubstraction = ccpSub(obstaclePosition, playeurPosition);
        float distanceCarree = soubstraction.x * soubstraction.x + soubstraction.y * soubstraction.y;
        float dist = sqrtf(distanceCarree);
        float contentSize = ((__bridge CCSprite *)playerBody->GetUserData()).contentSize.width*((__bridge CCSprite *)playerBody->GetUserData()).scale;
        
        if (dist < contentSize/2 + rayonItems) {
            [self removeChild:schpritz cleanup:NO];
            [lesObstaclesDeTonPere removeObject:schpritz];
            [self diminuerPlayerDeltaScale:0.04];	
            [_audioManager play:@"Bonus.caf"];
			JNPScore *s = [JNPScore sharedInstance];
			[s setScore:[s getScore] - 250];
			[controlLayer showScore:[s getScore]];
            return;
        }
    }
}



// Auto scroll selon la position
-(void)updateViewPoint:(float)dt {
    float currentPlayerPosition = ((__bridge CCSprite *)playerBody->GetUserData()).position.x;
    float currentPlayerPosition_y = ((__bridge CCSprite *)playerBody->GetUserData()).position.y;
    self.position = ccp(200-currentPlayerPosition, self.position.y);
    float dp = currentPlayerPosition - prevPlayerPosition;
    float v = dp/dt;
	if (prevPlayerPosition == 0) { // on supprime le premier point.
		currentSpeed = 0;
	} else {
		currentSpeed=v;
	}
    
    JNPScore *s = [JNPScore sharedInstance];
    float leveldifficulty = 100.0+45.0*[s getLevel];
    
    
    if (v<leveldifficulty) {			
        float zeForce = (leveldifficulty - v + [controlLayer getAccelY]*forceAccel/forceFactor)/200;
        b2Vec2 force = b2Vec2(zeForce, 0.0f);
        playerBody->ApplyLinearImpulse(force, playerBody->GetPosition());
    }
    
	int musicStress = 1;
    //NSLog(@"currentScale %f", currentScale);
	if (currentScale < KSIZESMALL) {
		musicStress = 4;
	} else if (currentScale < KSIZEBIG) {
		musicStress = 1;
	} else {
		musicStress = 2;
	}
	
	if (musicStress != currentMusicStress) {
		[_audioManager playMusicWithStress:musicStress];
		currentMusicStress = musicStress;
	}
    
    [self checkCollisions:dt];
    
    //float speedFactor = [[NSString stringWithFormat:@"%f", fabs(currentSpeed)] length] * 0.1;
    //NSLog(@"speedFactor %f", speedFactor);
    //NSLog(@"currentSpeed %f", currentSpeed);
    
    //[parallax updateWithVelocity:ccp(-speedFactor, 0.001 * speedFactor) AndDelta:dt];
    [parallax updateWithVelocity:ccp(-currentSpeed*0.005, 0) AndDelta:dt];
    prevPlayerPosition = currentPlayerPosition;
    prevPlayerPosition_y = currentPlayerPosition_y;
}

-(void)updatePlayerPosFromPhysics:(float)dt {
    
	b2Body * b = playerBody;
    if (b->GetUserData() != NULL) {
        CCSprite *ballData = (__bridge CCSprite *)b->GetUserData();
        ballData.position = ccp(b->GetPosition().x * [Box2DHelper pointsToMeterRatio],
                                b->GetPosition().y * [Box2DHelper pointsToMeterRatio]);
        ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        float y = b->GetPosition().y;
        float x = b->GetPosition().x;
        if (y < 0) {
            [self gameover];
        }
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        if (y* [Box2DHelper pointsToMeterRatio] > size.height) {
            [self gameover];
        }
        
        if (x * [Box2DHelper pointsToMeterRatio] > [self limitLevelUp]) {
            // on vient de passer le checkpoint !
            // empêcher le game over
            hasWon=YES;
            [controlLayer setVisible:NO];
            [controlLayer setIsTouchEnabled:NO];
            // transition vers niveau suivant (voir comment on peut faire sans tout réinitialiser
            [self unscheduleAllSelectors];
            [self unscheduleUpdate];
            
            JNPScore * s = [JNPScore sharedInstance];
            s.vomis=lesVomisDeTaGrandMere;
            
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: [JNPBasicLayer scene:jnpNewLevel]]];
        }
        
    }        
    //}
    
}



-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
}

-(void) checkCollisions: (ccTime) dt
{
    float currentPlayerPosition = ((__bridge CCSprite *)playerBody->GetUserData()).position.x;
    float currentPlayerPosition_y = ((__bridge CCSprite *)playerBody->GetUserData()).position.y;
        
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin(); 
        pos != _contactListener->_contacts.end(); ++pos) {
       
        // not toooooo much boingboing
        if (fabs(prevPlayerPosition - currentPlayerPosition) >= 1
            && fabs(prevPlayerPosition_y - currentPlayerPosition_y) >= 1) {

            [_audioManager playJump];
        }
    }
    
}



#pragma mark -
#pragma mark Gestion du Sprite Player


-(void)tellPlayerToJump {
    float adjustedForce = (44.0 + (140.0 * currentScale))/forceFactor;
    //NSLog(@"CURRENTSCALE = %f  ADJUSTED FORCE = %f",currentScale, adjustedForce);
    
    b2Vec2 force = b2Vec2(0.25*adjustedForce, adjustedForce); //18
    playerBody->ApplyLinearImpulse(force, playerBody->GetPosition());
	
	b2Body * b = playerBody;
	if (b->GetUserData() != NULL) {
		CCSprite *ballData = (__bridge CCSprite *)b->GetUserData();
		[ballData setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
								   spriteFrameByName:@"elephant-saute.png"]];		
        //[self unschedule:@selector(restorePlayerTexture:)];
		[self scheduleOnce:@selector(restorePlayerTexture:) delay:0.3];
	}	
}


-(void)tellPlayerToPuke:(CGPoint)position {	
	// animation
	b2Body * b = playerBody;
	if (b->GetUserData() != NULL) {
		CCSprite *ballData = (__bridge CCSprite *)b->GetUserData();
		[ballData setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
								   spriteFrameByName:@"elephant-puke.png"]];		
        //[self unschedule:@selector(restorePlayerTexture:)];
		[self scheduleOnce:@selector(restorePlayerTexture:) delay:0.3];
        
        // ajout du vomi !
        CGPoint dasPunkt = ccp(ballData.position.x,ballData.position.y);
        CCSprite *vomi = [CCSprite spriteWithSpriteFrameName:[@"bonus_0" stringByAppendingFormat:@"%d.png",arc4random()%6+2]];
        vomi.position=dasPunkt;
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			vomi.scale = bonusMalusIPhoneScale;
		}
        [self addChild:vomi];
        [lesVomisDeTaGrandMere addObject:vomi];
    }
    
	// son
	[_audioManager playPuke];	
	
	[self diminuerPlayerDeltaScale:0.055];
    
}


-(void)restorePlayerTexture:(float)dt {
	b2Body * b = playerBody;
    if (b->GetUserData() != NULL) {
		CCSprite *ballData = (__bridge CCSprite *)b->GetUserData();
		[ballData setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
								   spriteFrameByName:@"elephant-normal.png"]];
	}
	//[self unschedule:@selector(restorePlayerTexture:)];
}



-(void)playerGrowWithBonus {
		currentScale += 0.15;
        
		if (playerBody->GetUserData() != NULL) {
            CCSprite *ballData = (__bridge CCSprite *)playerBody->GetUserData();
            ballData.scale=currentScale;
            playerBody->DestroyFixture(playerBody->GetFixtureList());
            b2CircleShape circle;
            circle.m_radius = elephantSize*currentScale/2/[Box2DHelper pixelsToMeterRatio];
            b2FixtureDef ballShapeDef;
            ballShapeDef.shape = &circle;
            ballShapeDef.density = 0.50/currentScale; //0.5f * currentScale;
            ballShapeDef.friction = KFRICTION;
            ballShapeDef.restitution = KREBONDISSEMENT;
            playerBody->CreateFixture(&ballShapeDef);
            
		}        

	
}




-(void)diminuerPlayerDeltaScale:(float)deltaScale {
    [self diminuerPlayerDeltaScale:deltaScale withEffect:YES];
}

-(void)diminuerPlayerDeltaScale:(float)deltaScale withEffect:(Boolean)effect {
    // diminuer taille
    
    if (currentScale > deltaScale) {
        currentScale -= deltaScale;
    } else {
        currentScale = 0.1f;
    }
	
	if (playerBody->GetUserData() != NULL) {
		CCSprite *ballData = (__bridge CCSprite *)playerBody->GetUserData();
		ballData.scale=currentScale;
		playerBody->DestroyFixture(playerBody->GetFixtureList());
		b2CircleShape circle;
		circle.m_radius = elephantSize*currentScale/2/[Box2DHelper pixelsToMeterRatio];
		b2FixtureDef ballShapeDef;
		ballShapeDef.shape = &circle;
		ballShapeDef.density = 0.50/currentScale; //0.5f * currentScale;
        ballShapeDef.friction = KFRICTION;
        ballShapeDef.restitution = KREBONDISSEMENT;
		playerBody->CreateFixture(&ballShapeDef);
		if (effect) {
            
            playerBody->ApplyTorque(50.0);
            
            // Effets visuels
            // Création d'un sprite avec l'image de l'éléphant, puis scale et alpha animés
            CGPoint currentPlayerPosition = ballData.position;
            CCSprite *effetVisuel = [CCSprite spriteWithSpriteFrameName:@"elephant-normal.png"];
            effetVisuel.position = currentPlayerPosition;
            effetVisuel.rotation = ballData.rotation;
            effetVisuel.color = ccc3(255.0, 180.0, 180.0);
            effetVisuel.opacity = 90.0;
            [self addChild:effetVisuel];
            
            float newScale = ballData.scale * 1.5;
            if (newScale>1.0) {
                newScale *= 0.7;
            }
            if (newScale>2.0) {
                newScale *= 0.7;
            }
            
            id actionScale = [CCScaleBy actionWithDuration:0.4 scale:ballData.scale];
            id actionOpacity = [CCActionTween actionWithDuration:0.25 key:@"opacity" from:90 to:0];
            id actionDone = [CCCallFuncN actionWithTarget:self 
                                                 selector:@selector(delSprite:)];
            
            [effetVisuel runAction:actionOpacity];
            [effetVisuel runAction:[CCSequence actions:actionScale, actionDone, nil]];
        }
	}   
}

-(void)delSprite:(id)sender {
    [self removeChild:sender cleanup:YES];
}




-(void)gameover
{
	if (!hasWon) {
		[self unscheduleAllSelectors];
		[self unscheduleUpdate];
		[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: [JNPBasicLayer scene:jnpGameover]]];
	}
	
}



#pragma mark gestion taille d'écran

-(int)limitLevelUp
{
	int ret = 0;
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		if( CC_CONTENT_SCALE_FACTOR() == 2 )
			ret = 24150; // ipad retina
		else
			ret = 24150; // ipad
	}
	else
	{
		if( CC_CONTENT_SCALE_FACTOR() == 2 )
			ret = 12300; // iphone retina
		else
			ret = 12300; // iphone
	}

	return ret;
}



#pragma mark DRAW DEBUG DATA ICI !!!
/*
-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
    
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
}
*/



#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark dealloc, getters, setters



// il y a vraiment des commentaires de merde dans ce code

-(void) dealloc
{
//	delete m_debugDraw;
//	m_debugDraw = NULL;
	delete _contactListener;
	_contactListener = NULL;
	delete world;
	world = NULL;

}	


@synthesize playerBody;
@synthesize tileMap = _tileMap;
@synthesize background = _background;



@end
