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
static NSString *obstacleName  = @"obstacleName";
static NSString *backgroundName  = @"backgroundName";
static NSString *itemName  = @"jumpObstacle";


static unsigned int obstacleGap = 150;
static unsigned int obstacleDistance = 100;

static unsigned int movingSpeed = 90;
static unsigned int fireFlyMoveSpeed = 1;
static unsigned int acceleration = 1;


static const uint32_t playerCategory =  0x1 << 0;
static const uint32_t movingShapeCategory = 0x1 << 1;
static unsigned int collisionBitMask = 0;

static const uint32_t borderCategory     =  4;



#endif
