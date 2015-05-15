//
//  Rope.h
//  firefly
//
//  Created by hoangpham on 6/5/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


@interface Rope : NSObject


@property(nonatomic, readonly) NSArray *ropeRings;

@property(nonatomic) int ringCount;

@property(nonatomic) CGFloat ringScale;

@property(nonatomic) CGFloat ringsDistance;

@property(nonatomic) CGFloat jointsFrictionTorque;

@property(nonatomic) CGFloat ringsZPosition;

@property(nonatomic) CGPoint startRingPosition;

@property(nonatomic) CGFloat ringFriction;

@property(nonatomic) CGFloat ringRestitution;

@property(nonatomic) CGFloat ringMass;


@property(nonatomic) BOOL shouldEnableJointsAngleLimits;

@property(nonatomic) CGFloat jointsLowerAngleLimit;

@property(nonatomic) CGFloat jointsUpperAngleLimit;



-(instancetype)initWithRingTexture:(SKTexture *)ringTexture;


-(void)buildRopeWithScene:(SKScene *)scene;

-(void)adjustRingPositions;

-(SKSpriteNode *)startRing;

-(SKSpriteNode *)lastRing;


@end
