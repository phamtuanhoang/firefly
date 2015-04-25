//
//  GamePlayer.h
//  firefly
//
//  Created by hoangpham on 23/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Background.h"

@interface GamePlayer : SKScene<SKPhysicsContactDelegate>

@property (assign) CFTimeInterval lastUpdateTimeInterval;
@property (strong, nonatomic) Background *currentBackground;

@end
