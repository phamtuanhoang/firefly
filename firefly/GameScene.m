//
//  GameScene.m
//  firefly
//
//  Created by hoangpham on 18/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "GameScene.h"
#import "Firefly.h"
#import "Obstacles.h"
#import "Common.h"
#import "Level.h"
#import "GameData.h"
#import "GameOver.h"
#import "GameIntroScene.h"
#import "GamePlayer.h"
#import "Item.h"

@implementation GameScene
{
    
    BOOL gTouchDown;
    float playerSpeed;					/* current movement speed */
    float playerAcceleration;			/* acceleration to boost speed */
    float playerFriction;				/* friction slow down speed when not touched */
    
    NSInteger *nodeCount;
    NSMutableArray *obstaclesArray;
    int totalNodeCount;
    
    //label
    SKLabelNode *scoreLabel;
    
    //add help item
    BOOL addHelpItem;
    
    //point
    int point;
    
    Level *level;
    Firefly *fireFly;
    
    long currentSpeed;
    //check is power up
    BOOL powerup;
    BOOL displayPowerUp;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.currentBackground = [Background generateNewBackground];
        self.currentBackground.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        [self addChild:self.currentBackground];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;

    
    addHelpItem = true;
    //set up level instance
    level = [[Level alloc] init];
    
    //initialize speed
    currentSpeed = level.speed;
    powerup = NO;
    displayPowerUp = NO;
    
    [self setUpFireFly];
    [self setUpObstacle];
    [self addScoreLabel];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endPowerUp:) name:@"EndPowerUp_Notification" object:nil];
   
}

-(void)addScoreLabel
{
    //add score label
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:font];
    scoreLabel.fontColor = [SKColor greenColor];
    scoreLabel.name = scoreName;
    scoreLabel.text = [NSString stringWithFormat:@"%ld", [GameData sharedGameData].highScore];

    scoreLabel.fontSize = 50;
    scoreLabel.position = CGPointMake(CGRectGetWidth(self.frame) - 50, CGRectGetHeight(self.frame) - 50);
    scoreLabel.zPosition = 2;
    [self addChild:scoreLabel];
    point = 0;
}

-(void)setUpObstacle
{
    //start initialize obstacle from middle of the screen
    float current_pos = 0;
    float random_x=0;
    float random_y=0;

    float randomObsctacleDistance = 0;
    float randomObsctacleGap = 0;

    while (TRUE) {
        Obstacles *obs = [[Obstacles alloc]init];
        
        //random x position
        random_x = arc4random_uniform(CGRectGetWidth(self.frame) - level.obstacleDistance);
        random_x = random_x - CGRectGetWidth(self.frame)/2 ;
        obs.size = CGSizeMake(self.frame.size.width, 20.0);
        obs.position = CGPointMake(random_x,CGRectGetHeight(self.frame) + current_pos);
        obs.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:obs.size];
        obs.physicsBody.categoryBitMask = movingShapeCategory;
        obs.physicsBody.contactTestBitMask = playerCategory;
        obs.physicsBody.usesPreciseCollisionDetection = YES;
        obs.physicsBody.collisionBitMask = collisionBitMask;
        obs.physicsBody.dynamic = NO;

        [self addChild:obs];
        
        randomObsctacleDistance = arc4random_uniform(level.obstacleDistance);
        
        Obstacles *leftNode = [[Obstacles alloc]init];
        leftNode.position = CGPointMake(random_x +self.frame.size.width + level.obstacleDistance + randomObsctacleDistance,CGRectGetHeight(self.frame) + current_pos);
        leftNode.size = CGSizeMake(self.size.width, 20.0);
        leftNode.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:leftNode.size];
        leftNode.physicsBody.categoryBitMask = movingShapeCategory;
        leftNode.physicsBody.contactTestBitMask = playerCategory;
        leftNode.physicsBody.usesPreciseCollisionDetection = YES;
        leftNode.physicsBody.collisionBitMask = collisionBitMask;
        leftNode.physicsBody.dynamic = NO;
        [self addChild:leftNode];
        
        //randome obstacle gap
        random_y = arc4random_uniform(obstacleMinGapLowSpeed);
        random_y += obstacleMinGapLowSpeed;
        current_pos += random_y;
        
        if (current_pos >= CGRectGetMidY(self.frame)*3.0) {
            break;
        }
    }
}

-(void)setUpFireFly
{
    fireFly = [[Firefly alloc]init];
    playerSpeed = 0;
    playerAcceleration = 0;
    playerFriction = fireFly.playerFriction;
//    fireFly.shielded = true;
    fireFly.position =CGPointMake(CGRectGetMidX(self.frame),50);
    [self addChild:fireFly];
}


/*
    setupGame Over Scene
*/
-(void)gameOverScene
{
   
    //gameOverScene.zPosition = 1;
    
    for (SKNode* node in self.children) {
        node.paused = YES;
    }
    
    [self runAction:
     [SKAction sequence:@[
                          [SKAction waitForDuration:1.0],
                          [SKAction runBlock:^{
                                SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
                                GameOver *gameOverScene = [[GameOver alloc] initWithSize:self.size];
                                [self.view presentScene:gameOverScene transition: reveal];
                            }]
                          ]
      ]];
}

/*
    replay clicked
 */
-(void)replayGame:(NSNotification *)notification
{
    [self.view presentScene:nil];
    [self removeFromParent];
    self.scene.view.paused = NO;
}



-(void)addObstacle
{
    float random_x=0;
    float random_y=0;

    random_x = arc4random_uniform(CGRectGetWidth(self.frame) - level.obstacleDistance);
    random_x = random_x - CGRectGetWidth(self.frame)/2 ;

    
    float lastNodePos = [self getHighestNodePos];
    float randomObsctacleDistance = 0;
    
    //randome obstacle gap
    if (level.level > 2) {
        random_y = arc4random_uniform(obstacleMinGapHighSpeed);
        random_y += obstacleMinGapHighSpeed;
    }else{
        random_y = arc4random_uniform(obstacleMinGapLowSpeed);
        random_y += obstacleMinGapLowSpeed;
    }
    
    
    

    
    Obstacles *rightNode = [[Obstacles alloc]init];
    rightNode.position = CGPointMake(random_x,lastNodePos + random_y);
    rightNode.size = CGSizeMake(self.frame.size.width, 20.0);
    rightNode.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:rightNode.size];
    rightNode.physicsBody.categoryBitMask = movingShapeCategory;
    rightNode.physicsBody.contactTestBitMask = playerCategory;
    rightNode.physicsBody.usesPreciseCollisionDetection = YES;
    rightNode.physicsBody.collisionBitMask = collisionBitMask;
    rightNode.physicsBody.dynamic = NO;


    [self addChild:rightNode];
    randomObsctacleDistance = arc4random_uniform(level.obstacleDistance);
    
    Obstacles *leftNode = [[Obstacles alloc]init];
    leftNode.position = CGPointMake(random_x + self.frame.size.width +level.obstacleDistance + randomObsctacleDistance,lastNodePos + random_y);
    leftNode.size = CGSizeMake(self.frame.size.width, 20.0);
    leftNode.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:leftNode.size];
    leftNode.physicsBody.categoryBitMask = movingShapeCategory;
    leftNode.physicsBody.contactTestBitMask = playerCategory;
    leftNode.physicsBody.usesPreciseCollisionDetection = YES;
    leftNode.physicsBody.collisionBitMask =collisionBitMask;
    leftNode.physicsBody.dynamic = NO;

    [self addChild:leftNode];
    
    
    if(level.showPowerUp){
        //check if already have power up item
        SKNode *temp = [self childNodeWithName:powerUpItem];
        if (!temp) {
            random_x = arc4random_uniform(CGRectGetWidth(self.frame)/2);
            random_x += CGRectGetWidth(self.frame)/4 ;
            
            Item *powerUp = [[Item alloc] init];
            powerUp.position =CGPointMake(random_x,lastNodePos + random_y/2);
            powerUp.name = powerUpItem;
            [self addChild:powerUp];
            //level.showPowerUp = NO;
            NSLog(@"CurrentScore: %ld", [GameData sharedGameData].score);
            NSLog(@"Add item");
        }
        
    }
}

-(int)getHighestNodePos
{
    float nodePosTmp = 0;
    float tempPos;
    
    //remove play button
    for (SKNode* node in self.children) {
        if (node.name == obstacleName) {
            tempPos = node.position.y;
            if (tempPos > nodePosTmp) {
                nodePosTmp = tempPos;
            }
        }
    }
    return nodePosTmp;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    //Firefly *firefly = (Firefly *)[self nodeAtPoint:[touch locationInNode:self]];
    // set touch down to true
    gTouchDown = true;
    
    /* Determine movement direction */
    if( location.x <= self.frame.size.width / 2 ) {
        // move left set acceleration to negative
        playerAcceleration = -fireFly.playerAcceleration;
    }
    else {
        // move right set acceleration to negative
        playerAcceleration = fireFly.playerAcceleration;
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    gTouchDown = false;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    /* Called before each frame is rendered */
    //calculate time since last Update
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    
    //if more than a second
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0/60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    //handline moving of player
    [self enumerateChildNodesWithName:obstacleName usingBlock:^(SKNode *node, BOOL *stop) {
        //if move out of the screen
       node.position = CGPointMake(node.position.x, node.position.y - timeSinceLast*currentSpeed);
    
        
        if ((node.position.y < 0)) {
            [node removeFromParent];
            [self addObstacle];
            [self updatePointLabel];
        }
    }];
    
    //handline moving of item
    [self enumerateChildNodesWithName:powerUpItem usingBlock:^(SKNode *node, BOOL *stop) {
        //if move out of the screen
        node.position = CGPointMake(node.position.x, node.position.y
                                    - timeSinceLast*currentSpeed);
        if ((node.position.y < 0)) {
            [node removeFromParent];
        }
    }];


    
    [self enumerateChildNodesWithName:fireflyName usingBlock:^(SKNode *node, BOOL *stop) {
        /********************************************/
        /*                                          */
        /* calculate new velocity with acceleration */
        /*                                          */
        /********************************************/
        
        // decrease previous frame speed by friction
        // speed is decreased over time by friction from previous frame
        
        // apply new instant boosting acceleration (* if any by Touch *)
        // speed is boosted by instant acceleration
        if( gTouchDown == true )
        {
            playerSpeed += playerAcceleration;
        }else
        {
            playerSpeed *= playerFriction;
            
        }
        // set boosting acceleration to zero after applied
        // so that if no touch occur, no boosting of speed is applied
        playerAcceleration = 0;
        
        // set a minimum trim off value for speed to disappear totally
        // check if speed is too small (+ / -)
        if( fabs( playerSpeed ) < 0.01 )
        {
            // speed is too small after friction applied many times
            // so we simply set it to ZERO to avoid small movement appear on screen
            playerSpeed = 0;
        }
        
        /********************************************/
        /*                                    		*/
        /* update position with new speed			*/
        /*                                          */
        /********************************************/
        
        node.position = CGPointMake( node.position.x + playerSpeed , node.position.y );
        
        /********************************************/
        /*                                    		*/
        /* boundary problem restriction				*/
        /*                                          */
        /********************************************/
        float minBorder = 10;
        float maxBorder = self.frame.size.width - 10;
        
        if( node.position.x <= minBorder )
        {
            node.position = CGPointMake( minBorder , node.position.y );
        }
        
        else if( node.position.x >= maxBorder )
        {
            node.position = CGPointMake( maxBorder , node.position.y );
        }
    }];
    
}


-(void)updatePointLabel
{
    point+=1;
    [GameData sharedGameData].score = point/2;
    scoreLabel.text = [ NSString stringWithFormat:@"%ld", [GameData sharedGameData].score];
    [level updateLevel:(int)[GameData sharedGameData].score];
    
    if(!powerup){
        currentSpeed = level.speed;
    }
    [level displayPowerUp:(int)[GameData sharedGameData].score];

}


-(void)checkCollision
{
    //stop moving objects
    currentSpeed = 0.0;
    playerSpeed = 0.0;
    self.userInteractionEnabled = NO;
    
    
    //save high score
    [GameData sharedGameData].highScore = MAX([GameData sharedGameData].score,
                                              [GameData sharedGameData].highScore);

    [[GameData sharedGameData] save];
    [[GameData sharedGameData] reset];
    
    //display game over scene
    [self gameOverScene];

}

/*
    check power up
 */
-(void)checkPowerUp
{
    currentSpeed = powerUpSpeed;
    powerup = YES;
    fireFly.isPowerUp = YES;
}

-(void)endPowerUp:(NSNotification *)notification
{
    powerup = NO;
}


/*
 
 handling contact of the sprite
 
 */

-(void)didBeginContact:(SKPhysicsContact *)contact {
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    // 2
    if ((firstBody.categoryBitMask & playerCategory) != 0 &&
        (secondBody.categoryBitMask & movingShapeCategory) != 0)
    {
        [self checkCollision];
    }
    // 3
    if ((firstBody.categoryBitMask & playerCategory) != 0 &&
        (secondBody.categoryBitMask & itemCategory) != 0)
    {
        [self checkPowerUp];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EndPowerUp_Notification" object:nil];
}


@end
