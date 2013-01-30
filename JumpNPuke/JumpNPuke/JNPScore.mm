//
//  JNPScore.mm
//  JumpNPuke
//
//  Created by Alain Vagner on 29/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPScore.h"

static JNPScore * instance = nil;

@implementation JNPScore

+(id)sharedInstance {
	DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
		return instance = [[self alloc] init];
	});
}

- (id)init {
    self = [super init];
    if (self) {
		level=1;
		score=0;
		time=90;
    }
    return self;
}

-(int)getScore
{
	return score;
}

-(void)setScore:(int)s
{
	if (s >= 0) {
		score = s;
	} else {
		score =0;
	}
}

-(void)incrementScore:(int)s
{
	score+=s;	
}

-(int)getLevel
{
	return level;
}

-(void)setLevel:(int)l
{
	level = l;
}

-(void)incrementLevel
{
	level++;	
}

-(int)getTime
{
	return time;
}

-(void)setTime:(int)t
{
	time=t;
}

-(void)decrementTime
{
	if (time!=0) {
		time--;
	}
}


@synthesize vomis;

@end
