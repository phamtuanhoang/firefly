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
        self.currentBackground = [Background generateGameIntroBackground];
        self.currentBackground.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        [self addChild:self.currentBackground];
        
        // 3
        tapBtn = [SKSpriteNode spriteNodeWithImageNamed:@"Button_Start"];
        tapBtn.position = CGPointMake(CGRectGetMidX(self.frame) ,CGRectGetMidY(self.frame)-200 );
        tapBtn.name = gameIntroTap;
        tapBtn.size =  CGSizeMake(100.0, 150.0);

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
        SKTransition *reveal =[SKTransition crossFadeWithDuration:1.0];
        GameScene * scene = [GameScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
        
    }
}
-(void)dealloc
{
    if (self.scene !=nil) {
        [self.scene removeAllChildren];
        [self.scene removeFromParent];
    }
}


@end
