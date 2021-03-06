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
@synthesize shield;
@synthesize engineEmitter,powerUpEmitter;

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
        //self.alpha = 0.5;
        
        [self addChild:[self loadEmitterNode:@"Light"]];
    }
    
    
    
   
    //[self setupAnimations];

    self.playerAcceleration = fireFlyMoveSpeed;
    self.playerFriction = 0.95f;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeColorWhenReachNewLevel:) name:@"NewLevel_Notification" object:nil];
    

    return self;
}


- (SKEmitterNode *)loadEmitterNode:(NSString *)emitterFileName
{
    NSString *emitterPath = [[NSBundle mainBundle] pathForResource:emitterFileName ofType:@"sks"];
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
    
    //do some view specific tweaks
    emitterNode.particlePosition = CGPointMake(0, -self.size.height/2);
    //emitterNode.hidden = NO;
    
    return emitterNode;
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
                                                         shieldOnFrames timePerFrame:0.1 resize:YES restore:NO]]
                           withKey:@"shieldOn"];
            //self.physicsBody.categoryBitMask = itemCategory;
        }
    } else if (_shielded) {
        [self blinkRed];
        [self.shield removeActionForKey:@"shieldOn"];
        [self.shield runAction:[SKAction animateWithTextures:self.
                                shieldOffFrames timePerFrame:0.15 resize:YES restore:NO]
                       withKey:@"shieldOff"];
        self.physicsBody.categoryBitMask = itemCategory;
        [self.shield removeActionForKey:@"shieldOff"];
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


-(void)changeColorWhenReachNewLevel:(NSNotification *)notification
{
    
    NSDictionary *levelInfo = notification.userInfo;
    NSNumber* currentLevel = [levelInfo valueForKey:@"CurrentLevel"];
    int getLevel = [currentLevel floatValue];
    if (getLevel == 1){
        self.engineEmitter.particleColorSequence = nil;
        self.engineEmitter.particleColorBlendFactor = 1.0;
        self.engineEmitter.particleColor = [SKColor redColor];
    }else if (getLevel == 2){
        self.engineEmitter.particleColorSequence = nil;
        self.engineEmitter.particleColorBlendFactor = 1.0;
        self.engineEmitter.particleColor = [SKColor greenColor];
    }else if (getLevel == 3){
        self.engineEmitter.particleColorSequence = nil;
        self.engineEmitter.particleColorBlendFactor = 1.0;
        self.engineEmitter.particleColor = [SKColor yellowColor];
    }else if (getLevel == 4){
        self.engineEmitter.particleColorSequence = nil;
        self.engineEmitter.particleColorBlendFactor = 1.0;
        self.engineEmitter.particleColor = [SKColor colorWithRed:20 green:20 blue:20 alpha:0.5];
    }else{
        self.engineEmitter.particleColorSequence = nil;
        self.engineEmitter.particleColorBlendFactor = 0.5;
        self.engineEmitter.particleColor = [SKColor orangeColor];
    }
   
}

/*
    power up
*/
-(void)setIsPowerUp:(BOOL)isPowerUp
{
    if (isPowerUp) {
        //power up emitter
        self.powerUpEmitter = [NSKeyedUnarchiver
                               unarchiveObjectWithFile:
                               [[NSBundle mainBundle]
                                pathForResource:@"powerUp" ofType:@"sks"]];
        self.powerUpEmitter.position = CGPointMake(0, -self.size.height);
        self.powerUpEmitter.name = fireflyPowerUp;
        //self.powerUpEmitter.physicsBody.categoryBitMask = powerUpStateCategory;
        [self addChild:self.powerUpEmitter];
        self.powerUpEmitter.hidden = NO;
        self.physicsBody.categoryBitMask = powerUpStateCategory;
      
        SKAction *removePowerup = [SKAction waitForDuration:4];
        [self runAction:removePowerup completion:^{
            self.powerUpEmitter.particleBirthRate = 0;
            
            self.isPowerUp = NO;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"EndPowerUp_Notification"
             object:self userInfo:nil];
            
            SKAction *updatePlayerCategory = [SKAction waitForDuration:0.5];
            [self runAction:updatePlayerCategory completion:^{
                self.physicsBody.categoryBitMask = playerCategory;
                
            }];
        }];
        
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewLevel_Notification" object:nil];
}
@end
