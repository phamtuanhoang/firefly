//
//  Obstacles.m
//  firefly
//
//  Created by hoangpham on 17/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "Obstacles.h"
#import "Common.h"

@implementation Obstacles
@synthesize countValue;

-(instancetype)init
{
    self = [super initWithImageNamed:@"rectangleBlack"];
    {
        self.name = obstacleName;
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = movingShapeCategory;
        self.physicsBody.contactTestBitMask = playerCategory;
        self.physicsBody.usesPreciseCollisionDetection = YES;
        self.physicsBody.collisionBitMask = collisionBitMask;
        self.physicsBody.dynamic = NO;
    }
    return self;
}


@end
