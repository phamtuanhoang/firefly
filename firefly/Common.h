//
//  Common.h
//  firefly
//
//  Created by hoangpham on 17/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#ifndef firefly_Common_h
#define firefly_Common_h

static NSString *fireflyName  = @"fireflyName";
static NSString *fireflyParticle  = @"fireflyParticle";
static NSString *fireflyPowerUp  = @"fireflyPowerup";


static NSString *obstacleName  = @"obstacleName";
static NSString *obstacleMaster  = @"obstacleMaster";

static NSString *backgroundName  = @"backgroundName";
static NSString *powerUpItem  = @"powerUpItem";
static NSString *bottleItem  = @"bottleItem";
static NSString *tie  = @"tieItem";




static unsigned int obstacleGap = 150;

static unsigned int movingSpeed = 150;
static unsigned int fireFlyMoveSpeed = 3;
static unsigned int fireFlyMoveSpeed2 = 5;

static unsigned int acceleration = 2;

static unsigned int obstacleMinDistance = 40;
static unsigned int obstacleMinGapLowSpeed = 200;
static unsigned int obstacleMinGapHighSpeed = 250;



static unsigned int level1MovingSpeed = 30;
static unsigned int level1obstacleGap = 400;
static unsigned int level1ObstacleMin = 80;


static unsigned int level2MovingSpeed = 30;
static unsigned int level2obstacleGap = 400;
static unsigned int level2ObstacleMin = 60;


static unsigned int level3MovingSpeed = 20;
static unsigned int level3obstacleGap = 400;
static unsigned int level3ObstacleMin = 60;


static unsigned int level4MovingSpeed = 10;
static unsigned int level4obstacleGap = 400;
static unsigned int level4ObstacleMin = 60;


static unsigned int powerUpSpeed = 450;



static const uint32_t playerCategory =  0x1 << 0;
static const uint32_t movingShapeCategory = 0x1 << 1;
static unsigned int collisionBitMask = 0;

static const uint32_t itemCategory     =  8;
static const uint32_t particleCategory     =  16;
static const uint32_t powerUpStateCategory     =  32;



static NSString *font = @"Arial Rounded MT Bold";
static NSString *scoreName = @"Score";

static NSString *DataHighScoreKey = @"highScoreKey";


//game over
static NSString *gameOverSceneName = @"GameOver";
static NSString *gameOver = @"Game Over";
static NSString *replay = @"Replay";
static NSString *shareOnFb = @"F";
static NSString *shareonTwitter = @"T";
static NSString *leaderBoard = @"Leader Board";
static NSString *soundName = @"sound";



//game intro
static NSString *gameIntroTap = @"Tap";
static NSString *gameIntroName = @"GameIntroScene";

//game intro
static NSString *rope = @"Rope";



#endif
