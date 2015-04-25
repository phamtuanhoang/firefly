//
//  GameIntroScene.m
//  MatchingRush
//
//  Created by hoangpham on 31/3/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "GameIntroScene.h"
#import "Common.h"
#import "GameScene.h"
#import "Firefly.h"

@implementation GameIntroScene

SKSpriteNode *tapBtn;
SKSpriteNode *upArrow;
SKSpriteNode *downArrow;



-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // 1
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        
        // 3
        tapBtn = [SKSpriteNode spriteNodeWithImageNamed:@"tap.png"];
        tapBtn.position = CGPointMake(CGRectGetMidX(self.frame) ,CGRectGetMidY(self.frame) );
        tapBtn.name = gameIntroTap;
        tapBtn.zPosition = 1.0;
        [self addChild:tapBtn];
        
        
        
    }
    return self;
}


//handle touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:[touch locationInNode:self]];
    
    if (node.name == gameIntroTap)
    {
        SKTransition *reveal =[SKTransition revealWithDirection:SKTransitionDirectionDown duration:0.5];
        GameScene * scene = [GameScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
        
    }
   
}

@end
