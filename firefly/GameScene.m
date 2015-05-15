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
#import "Bottle.h"
#import "Tie.h"
#import "Rope.h"

@implementation GameScene
{
    
    BOOL gTouchDown;
    float playerSpeed;					/* current movement speed */
    float playerAcceleration;			/* acceleration to boost speed */
    float playerFriction;				/* friction slow down speed when not touched */
    
    
    //label
    SKLabelNode *scoreLabel;
    
    //add help item
    BOOL addHelpItem;
    
    //point
    int point;
    
    //random image in brach array
    unsigned int *randomBranch;
    
    Level *level;
    Firefly *fireFly;
    
    long currentSpeed;
    //check is power up
    BOOL powerup;
    BOOL displayPowerUp;
    
    //handle swipe
    UISwipeGestureRecognizer* swipeUpGesture;
    UISwipeGestureRecognizer* swipeDownGesture;
    BOOL checkIfSwipe;
    
    NSMutableArray *brachTexture;
    
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

    [self initBrachTexture];
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
    
    swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeUp:)];
    [swipeUpGesture setDirection: UISwipeGestureRecognizerDirectionUp];
    [view addGestureRecognizer:swipeUpGesture];
   
    swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeDown:)];
    [swipeDownGesture setDirection: UISwipeGestureRecognizerDirectionDown];
    [view addGestureRecognizer:swipeDownGesture];
    checkIfSwipe = NO;
    
    


    
}

-(void)initBrachTexture{
    NSString *imageName;
    brachTexture = [[NSMutableArray alloc] init];
    for (int i=0; i<7; i++) {
        imageName = [NSString stringWithFormat:@"Branches_%d",i];
        SKTexture *textture = [SKTexture textureWithImageNamed:imageName];
        [brachTexture addObject:textture];
    }
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
    

    while (TRUE) {

        
        Obstacles *obs = [[Obstacles alloc] initWithTexture:[brachTexture objectAtIndex:arc4random() % [brachTexture count]]];
        
        //random x position
        random_x = arc4random_uniform(CGRectGetWidth(self.frame) - level.obstacleDistance);
        random_x = random_x - CGRectGetWidth(self.frame)/2 ;
        obs.size = CGSizeMake(self.frame.size.width, 40.0);
        obs.position = CGPointMake(random_x,CGRectGetHeight(self.frame) + current_pos);
        [self setupPhysicalBody:obs];
        [self addChild:obs];
        
        randomObsctacleDistance = arc4random_uniform(level.obstacleDistance);
        
        Obstacles *leftNode = [[Obstacles alloc] initWithTexture:[brachTexture objectAtIndex:arc4random() % [brachTexture count]]];

        leftNode.position = CGPointMake(random_x +self.frame.size.width + level.obstacleDistance + randomObsctacleDistance,CGRectGetHeight(self.frame) + current_pos);
        leftNode.size = CGSizeMake(self.size.width, 40.0);
        [self setupPhysicalBody:leftNode];
        [self addChild:leftNode];
        
        //randome obstacle gap
        random_y = arc4random_uniform(obstacleMinGapLowSpeed);
        random_y += obstacleMinGapLowSpeed;
        current_pos += random_y;
        
        if (current_pos >= CGRectGetMidY(self.frame)*3.0) {
            break;
        }
        //[self buildRope:obs];
        //[self buildRope:leftNode];
    }
}


/*
    attach rope to the branch
 */
-(void)buildRope:(SKSpriteNode *)branch
{
    Rope *rope = [[Rope alloc] initWithRingTexture:[SKTexture textureWithImageNamed:@"rope_ring"]];
    rope.startRingPosition = CGPointMake(branch.position.x + branch.size.width/4, branch.position.y);//default is (0, 0)
    rope.ringCount = 10;//default is 30
    [rope buildRopeWithScene:self];
    
    //attach rope to branch
    SKSpriteNode *startRing = [rope startRing];
    CGPoint jointAnchor = CGPointMake(startRing.position.x, startRing.position.y + startRing.size.height / 2);
    SKPhysicsJointPin *joint = [SKPhysicsJointPin jointWithBodyA:branch.physicsBody bodyB:startRing.physicsBody anchor:jointAnchor];
    [self.physicsWorld addJoint:joint];
    
}

-(void)setUpFireFly
{
    fireFly = [[Firefly alloc]init];
    playerSpeed = 0;
    playerAcceleration = 0;
    playerFriction = fireFly.playerFriction;
    fireFly.position =CGPointMake(CGRectGetMidX(self.frame),50);
    [self addChild:fireFly];
}

-(void)setupPhysicalBody:(Obstacles *)obstacles
{
    obstacles.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:obstacles.size];
    obstacles.physicsBody.categoryBitMask = movingShapeCategory;
    obstacles.physicsBody.contactTestBitMask = playerCategory;
    obstacles.physicsBody.usesPreciseCollisionDetection = YES;
    obstacles.physicsBody.collisionBitMask = collisionBitMask;
    obstacles.physicsBody.dynamic = NO;
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
                                SKTransition *reveal = [SKTransition crossFadeWithDuration:1.0];
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
    
    //random obstacle gap
    random_y = arc4random_uniform(obstacleMinGapHighSpeed);
    random_y += obstacleMinGapHighSpeed;
    
    
    
    Obstacles *obs = [[Obstacles alloc] initWithTexture:[brachTexture objectAtIndex:arc4random() % [brachTexture count]]];

    //random x position
    obs.size = CGSizeMake(self.frame.size.width, 40.0);
    obs.position = CGPointMake(random_x,lastNodePos + random_y);
    [self setupPhysicalBody:obs];
    [self addChild:obs];
    
    //[self buildRope:obs];

    randomObsctacleDistance = arc4random_uniform(level.obstacleDistance);
    
    Obstacles *leftNode = [[Obstacles alloc] initWithTexture:[brachTexture objectAtIndex:arc4random() % [brachTexture count]]];

    leftNode.position = CGPointMake(random_x +self.frame.size.width + level.obstacleDistance + randomObsctacleDistance,lastNodePos + random_y);
    leftNode.size = CGSizeMake(self.size.width, 40.0);
    [self setupPhysicalBody:leftNode];
    [self addChild:leftNode];


    random_x = arc4random_uniform(leftNode.size.width/2);
        //[self addBottleAndJar:obs addLeftOrRight:YES];
    
        //[self addBottleAndJar:leftNode addLeftOrRight:NO];
  

    if(level.showPowerUp){
        //check if already have power up item
        SKNode *temp = [self childNodeWithName:powerUpItem];
        if (!temp) {
            random_x = arc4random_uniform(CGRectGetWidth(self.frame)/2);
            random_x += CGRectGetWidth(self.frame)/4 ;
            
            Item *powerUpItem = [[Item alloc] init];
            powerUpItem.position =CGPointMake(random_x,lastNodePos + random_y/2);
            [self addChild:powerUpItem];
        }
    }
}

/*
    add bottle and jar
 */
-(void)addBottleAndJar:(Obstacles *)obstacle addLeftOrRight:(BOOL)indication
{
    int random_x = arc4random_uniform(obstacle.size.width/4);
    if (indication) {
        //add left
        Tie *leftTie = [[Tie alloc] init];
        leftTie.position = CGPointMake(obstacle.position.x + obstacle.size.width/4+ random_x, obstacle.position.y-leftTie.size.height+obstacle.size.height/2);
        [self addChild:leftTie];
        //add bottle to catch the fire fly
        Bottle *leftBottle = [[Bottle alloc]init];
        leftBottle.position =CGPointMake(leftTie.position.x - leftTie.size.width/2,leftTie.position.y - leftTie.size.height/2);
        [self addChild:leftBottle];
    }else{
        //add tie on top the bottle
        Tie *rightTie = [[Tie alloc]init];
        rightTie.position = CGPointMake(obstacle.position.x-obstacle.size.width/4-random_x , obstacle.position.y-rightTie.size.height+obstacle.size.height/2);
        [self addChild:rightTie];
        
        
        //add bottle to catch the fire fly
        Bottle *rightBottle = [[Bottle alloc]init];
        rightBottle.position =CGPointMake(rightTie.position.x - rightTie.size.width/2,rightTie.position.y - rightTie.size.height/2);
        [self addChild:rightBottle];
    }
    
}




/*
    get highest position to add new obstacles
 */
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


/*
    handle swipe up and down
 */
-(void)handleSwipeUp:(UIGestureRecognizer *)recognizer
{
    if (checkIfSwipe) {
        currentSpeed = currentSpeed*2;
        checkIfSwipe = NO;
    }
}
-(void)handleSwipeDown:(UIGestureRecognizer *)recognizer
{
    currentSpeed = currentSpeed/2;
    checkIfSwipe = YES;
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
            [node runAction:[SKAction removeFromParent]];
            
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
            [node runAction:[SKAction removeFromParent]];
            node = nil;
        }
    }];
    
    //handline moving of bottle
    [self enumerateChildNodesWithName:bottleItem usingBlock:^(SKNode *node, BOOL *stop) {
        //if move out of the screen
        node.position = CGPointMake(node.position.x, node.position.y
                                    - timeSinceLast*currentSpeed);
        if ((node.position.y < 0)) {
            [node runAction:[SKAction removeFromParent]];
            node = nil;
        }
    }];

    
    //handline moving of tie
    [self enumerateChildNodesWithName:tie usingBlock:^(SKNode *node, BOOL *stop) {
        //if move out of the screen
        node.position = CGPointMake(node.position.x, node.position.y
                                    - timeSinceLast*currentSpeed);
        if ((node.position.y < 0)) {
            [node runAction:[SKAction removeFromParent]];
            node = nil;
        }
    }];
    
    //handline moving of rope
    [self enumerateChildNodesWithName:rope usingBlock:^(SKNode *node, BOOL *stop) {
        //if move out of the screen
        node.position = CGPointMake(node.position.x, node.position.y
                                    - timeSinceLast*currentSpeed);
        if ((node.position.y < 0)) {
            [node runAction:[SKAction removeFromParent]];
            node = nil;
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
