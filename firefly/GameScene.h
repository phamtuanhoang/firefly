//
//  GameScene.h
//  firefly
//

//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Background.h"

@class Background;
@interface GameScene : SKScene <SKPhysicsContactDelegate>
@property (assign) CFTimeInterval lastUpdateTimeInterval;
@property (strong, nonatomic) Background *currentBackground;

@end
