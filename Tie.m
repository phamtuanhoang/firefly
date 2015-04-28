//
//  Tie.m
//  firefly
//
//  Created by hoangpham on 28/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "Tie.h"
#import "Common.h"

@implementation Tie

-(instancetype)init
{
    self = [super initWithImageNamed:@"rectangleBlack"];
    {
        self.name = tie;
        self.size = CGSizeMake(20.0, 50.0);
        self.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.categoryBitMask = movingShapeCategory;
        self.physicsBody.contactTestBitMask = playerCategory;
        self.anchorPoint = CGPointMake(0, 0);
        self.physicsBody.dynamic = NO;

    }
    return self;
}

@end
