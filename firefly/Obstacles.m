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
    }
    return self;
}

- (int)getNodeCount
{
    return self.countValue;
}

-(void)setNodeCount:(int)nodeCountToAssign
{
    self.countValue = nodeCountToAssign;
}

@end
