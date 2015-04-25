//
//  Firefly.m
//  firefly
//
//  Created by hoangpham on 17/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "Firefly.h"
#import "Common.h"


@implementation Firefly
@synthesize playerAcceleration;

-(instancetype)init
{
    self = [super initWithImageNamed:@"cicleBlue"];
    {
        self.name = fireflyName;
        self.physicsBody.dynamic = NO;
        self.size = CGSizeMake(20.0, 20.0);
        self.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:self.size];
        
        self.physicsBody.categoryBitMask = playerCategory;
        self.physicsBody.contactTestBitMask = movingShapeCategory ;
        self.physicsBody.collisionBitMask = collisionBitMask ;
        self.physicsBody.dynamic = YES;
        self.physicsBody.usesPreciseCollisionDetection = YES;
        
        self.shield = [[SKSpriteNode alloc] init];
        //self.shield.size = CGSizeMake(30.0, 30.0);
        self.shield.blendMode = SKBlendModeAdd;
        [self addChild:self.shield];
    }
    [self setupAnimations];
    
    self.playerAcceleration = fireFlyMoveSpeed;
    self.playerFriction = 0.95f;
    return self;
}


-(void)setupAnimations
{
    self.shieldOnFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *shieldOnAtlas = [SKTextureAtlas
                                     atlasNamed:@"shieldRed"];
    for (int i = 0; i < [shieldOnAtlas.textureNames count]; i++) {
        NSString *tempName = [NSString
                              stringWithFormat:@"shield%d", i];
        SKTexture *tempTexture = [shieldOnAtlas
                                  textureNamed:tempName];
        if (tempTexture) {
            [self.shieldOnFrames addObject:tempTexture];
        }
    }
    
    self.shieldOffFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas *shieldOffAtlas = [SKTextureAtlas
                                      atlasNamed:@"deletePurple"];
    
    for (int i = 0; i < [shieldOffAtlas.textureNames count]; i++)
    {
        NSString *tempName = [NSString stringWithFormat:@"delete%d", i];
        SKTexture *tempTexture = [shieldOffAtlas
                                  textureNamed:tempName];
        if (tempTexture) {
            [self.shieldOffFrames addObject:tempTexture];
        } }
}


-(void)setShielded:(BOOL)shielded
{
    if (shielded) {
        if (![self.shield actionForKey:@"shieldOn"]) {
            [self.shield runAction:[SKAction
                                    repeatActionForever:[SKAction animateWithTextures:self.
                                                         shieldOnFrames timePerFrame:0.3 resize:YES restore:NO]]
                           withKey:@"shieldOn"];
        }
    }else if (_shield)
    {
        [self blinkRed];
        [self.shield removeActionForKey:@"shieldOn"];
        [self.shield runAction:[SKAction animateWithTextures:self.
                                shieldOffFrames timePerFrame:0.15 resize:YES restore:NO]
                       withKey:@"shieldOff"];
    }
    _shielded = shielded;
}

-(void)blinkRed
{
    SKAction *blinkRed = [SKAction sequence:@[
                                              [SKAction
                                               colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0
                                               duration:0.2],
                                              [SKAction
                                               waitForDuration:0.1],
                                              [SKAction
                                               colorizeWithColorBlendFactor:0.0 duration:0.2]]];
    [self runAction:blinkRed];
}

@end
