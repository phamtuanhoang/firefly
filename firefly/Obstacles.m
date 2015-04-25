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
        self.size = CGSizeMake(self.size.width, 20.0);
    }
    return self;
}


@end
