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
{
    SKTexture *_brachTexture;
}







-(instancetype)initWithTexture:(SKTexture *)texture
{
    self = [super initWithTexture:texture];
    {
        self.name = obstacleName;
    }
    return self;
}


@end