//
//  Level.m
//  firefly
//
//  Created by hoangpham on 22/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "Level.h"
#import "Common.h"

@implementation Level
@synthesize score,level,speed;


typedef enum{stage,m,t,w,th,f,sa} days;

-(instancetype)init
{
    self.score = 0;
    self.level = 0;
    self.speed = movingSpeed ;
    self.obstactGap = level1obstacleGap;
    self.obstacleDistance = level1ObstacleMin;
    return self;
}


-(void)updateLevel:(int)currentScore
{

    if (currentScore == 15) {
        self.speed += level1MovingSpeed;
        self.obstactGap = level1obstacleGap;
        //higher level, smaller distance
        self.obstacleDistance = level1ObstacleMin;
        self.level = 1;
        NSDictionary* currentLevel = @{@"CurrentLevel":[NSNumber numberWithFloat:self.level]};
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"NewLevel_Notification"
         object:self userInfo:currentLevel];
        
    }else if (currentScore == 25){
        self.speed += level2MovingSpeed;
        self.obstactGap = level2obstacleGap;
        //higher level, smaller distance
        self.obstacleDistance = level2ObstacleMin;
        self.level = 2;
        NSDictionary* currentLevel = @{@"CurrentLevel":[NSNumber numberWithFloat:self.level]};
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"NewLevel_Notification"
         object:self userInfo:currentLevel];
    }
    else if (currentScore == 35){
        self.speed += level3MovingSpeed;
        self.obstactGap = level3obstacleGap;
        //higher level, smaller distance
        self.obstacleDistance = level3ObstacleMin;
        self.level = 3;
        NSDictionary* currentLevel = @{@"CurrentLevel":[NSNumber numberWithFloat:self.level]};
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"NewLevel_Notification"
         object:self userInfo:currentLevel];
    }
    else if (currentScore == 45){
        self.speed += level4MovingSpeed;
        self.obstactGap = level4obstacleGap;
        //higher level, smaller distance
        self.obstacleDistance = level4ObstacleMin;
        self.level = 4;
        NSDictionary* currentLevel = @{@"CurrentLevel":[NSNumber numberWithFloat:self.level]};
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"NewLevel_Notification"
         object:self userInfo:currentLevel];
    }
}

-(void)displayPowerUp:(int)currentScore
{
    if (currentScore % 11 == 0) {
        self.showPowerUp = YES;
    }else{
        self.showPowerUp = NO;
    }
}



-(void)resetSpeed
{
    self.speed = movingSpeed;
    self.obstactGap = level1obstacleGap;
    self.obstacleDistance = level1ObstacleMin;
}



@end
