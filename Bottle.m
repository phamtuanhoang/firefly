//
//  Bottle.m
//  firefly
//
//  Created by hoangpham on 28/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "Bottle.h"
#import "Common.h"

@implementation Bottle




-(instancetype)init
{
    self = [super initWithImageNamed:@"bottle"];
    {
        self.name = bottleItem;
        self.size = CGSizeMake(40.0, 40.0);
        self.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width/2, self.frame.size.height/2)];
        self.physicsBody.categoryBitMask = movingShapeCategory;
        self.physicsBody.contactTestBitMask = playerCategory;
        self.physicsBody.dynamic = NO;
        self.anchorPoint = CGPointMake(0, 0);
        //SKAction *action = [SKAction rotateByAngle:-M_PI duration:10];
        //[self runAction:[SKAction repeatActionForever:action]];

    }
    return self;
}




@end
