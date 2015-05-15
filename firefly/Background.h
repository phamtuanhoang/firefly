//
//  Background.h
//  firefly
//
//  Created by hoangpham on 18/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Background : SKSpriteNode

+ (Background *)generateNewBackground;
+ (Background *)generateGameOverBackground;
+ (Background *)generateGameIntroBackground;


@end
