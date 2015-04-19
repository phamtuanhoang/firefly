//
//  Background.m
//  firefly
//
//  Created by hoangpham on 18/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "Background.h"
#import "Common.h"

@implementation Background

+ (Background *)generateNewBackground
{
    Background *background = [[Background alloc] init];
    background.color = [SKColor whiteColor];
    background.anchorPoint = CGPointMake(0, 0);
    background.name = backgroundName;
    background.position = CGPointMake(0, 0);
    return background;
}

@end
