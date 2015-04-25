//
//  GameOver.m
//  MatchingRush
//
//  Created by hoangpham on 8/3/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "GameOver.h"
#import "Common.h"
#import "GameScene.h"
#import "GameData.h"

@implementation GameOver
{
    SKSpriteNode *volumeBtn;
    SKTexture *soundOn;
    SKTexture *soundOff;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // 1
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
        SKSpriteNode *gameOverBtn = [SKSpriteNode spriteNodeWithImageNamed:@"gameover.png"];
        gameOverBtn.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+100);
        gameOverBtn.size = CGSizeMake(300.0, 150.0);
        gameOverBtn.name = gameOver;
        //gameOverBtn.zPosition = 1.0;
        
        [self addChild:gameOverBtn];
        
        
        
        SKSpriteNode *retryButton = [SKSpriteNode spriteNodeWithImageNamed:@"replay.png"];
        retryButton.position = CGPointMake(CGRectGetMidX(self.frame) - 100,CGRectGetMidY(self.frame) - 50);
        retryButton.size = CGSizeMake(40.0, 40.0);
        retryButton.name = replay;
        retryButton.zPosition = 1.0;
        [self addChild:retryButton];

        
        
        //add share on scocial button
        SKSpriteNode *facebook = [SKSpriteNode spriteNodeWithImageNamed:@"facebook.png"];
        facebook.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 50);
        facebook.size =  CGSizeMake(40.0, 40.0);
        facebook.name = shareOnFb;
        facebook.zPosition = 1.0;
        [self addChild:facebook];
        
        //add share on scocial button
        SKSpriteNode *twitter = [SKSpriteNode spriteNodeWithImageNamed:@"tweeter.png"];
        twitter.position = CGPointMake(CGRectGetMidX(self.frame) + 50,CGRectGetMidY(self.frame) - 50);
        twitter.size =  CGSizeMake(40.0, 40.0);
        twitter.name = shareonTwitter;
        twitter.zPosition = 1.0;
        [self addChild:twitter];
        
        
        //add share on facebook and twitter
        SKSpriteNode *leaderBoardBtn = [SKSpriteNode spriteNodeWithImageNamed:@"leaderboard.png"];
        leaderBoardBtn.position = CGPointMake(CGRectGetMidX(self.frame) - 50,CGRectGetMidY(self.frame) - 50);
        leaderBoardBtn.size =  CGSizeMake(40.0, 40.0);
        leaderBoardBtn.name = leaderBoard;
        leaderBoardBtn.zPosition = 1.0;
        [self addChild:leaderBoardBtn];
        
        
        soundOn = [SKTexture textureWithImageNamed:@"volume_up.png"];
        soundOff =[SKTexture textureWithImageNamed:@"no_volume.png"];
        volumeBtn = [SKSpriteNode spriteNodeWithTexture:soundOn];
        volumeBtn.position = CGPointMake(CGRectGetMidX(self.frame) + 100,CGRectGetMidY(self.frame) - 50);
        volumeBtn.size =  CGSizeMake(40.0, 40.0);
        volumeBtn.name = soundName;
        volumeBtn.zPosition = 1.0;
        [self addChild:volumeBtn];

    }
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onOffSound:) name:@"OnOffSound_Notification" object:nil];
    
    return self;
}

-(void)onOffSound:(NSNotification *)notification
{
    if (![GameData sharedGameData].isMusicON) {
        volumeBtn.texture = soundOn;

    }else{
        volumeBtn.texture = soundOff;
    }
}

//handle touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:[touch locationInNode:self]];
    
    if (node.name == replay)
    {
        SKTransition *reveal =  [SKTransition revealWithDirection:SKTransitionDirectionUp duration:1.0];

        GameScene * scene = [GameScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition:reveal];
        
    }else if (node.name == soundName)
    {
        [[GameData sharedGameData] setVolume];
    }
    
}

@end
