//
//  Firefly.h
//  firefly
//
//  Created by hoangpham on 17/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Firefly : SKSpriteNode
@property (strong, nonatomic) NSMutableArray *shieldOnFrames;;
@property (strong, nonatomic) NSMutableArray *shieldOffFrames;
@property (strong, nonatomic) SKSpriteNode *shield;
@property (assign, nonatomic) BOOL shielded;
@property (assign, nonatomic) float playerAcceleration;
@property (assign, nonatomic) float playerFriction;



@end
