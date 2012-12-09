//
//  JNPScore.h
//  JumpNPuke
//
//  Created by Alain Vagner on 29/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>
#import "GCDSingleton.h"



@interface JNPScore: NSObject {
    int score;
	int level;
	int time;
}
+(id)sharedInstance;
-(int)getScore;
-(void)setScore:(int)s;
-(void)incrementScore:(int)s;

-(int)getLevel;
-(void)setLevel:(int)l;
-(void)incrementLevel;

-(int)getTime;
-(void)setTime:(int)t;
-(void)decrementTime;

@property (strong) NSMutableArray *vomis;

@end
