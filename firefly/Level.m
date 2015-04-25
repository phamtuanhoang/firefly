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
    if (currentScore == 10) {
        self.speed += level1MovingSpeed;
        self.obstactGap = level1obstacleGap;
        //higher level, smaller distance
        self.obstacleDistance = level1ObstacleMin;
        self.level = 1;
        
    }else if (currentScore == 20){
        self.speed += level2MovingSpeed;
        self.obstactGap = level2obstacleGap;
        //higher level, smaller distance
        self.obstacleDistance = level2ObstacleMin;
        self.level = 2;

    }
    else if (currentScore == 30){
        self.speed += level3MovingSpeed;
        self.obstactGap = level3obstacleGap;
        //higher level, smaller distance
        self.obstacleDistance = level3ObstacleMin;
        self.level = 3;

    }
    else if (currentScore == 40){
        self.speed += level4MovingSpeed;
        self.obstactGap = level4obstacleGap;
        //higher level, smaller distance
        self.obstacleDistance = level4ObstacleMin;
        self.level = 5;

    }
}

-(void)resetSpeed
{
    self.speed = movingSpeed;
    self.obstactGap = level1obstacleGap;
    self.obstacleDistance = level1ObstacleMin;
}


@end
