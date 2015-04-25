//
//  GamePlayer.m
//  firefly
//
//  Created by hoangpham on 23/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "GamePlayer.h"
#import "Level.h"
#import "Firefly.h"
#import "Obstacles.h"
#import "Common.h"
#import "GameData.h"


@implementation GamePlayer
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
    BOOL passing;
    
    Level *level;

}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        
        NSLog(@"Move to View");

        
        //set up level instance
        level = [[Level alloc] init];
        
        [self setUpFireFly];
        [self setUpObstacle];
        [self addScoreLabel];

    }
    return self;
}


-(void)didMoveToView:(SKView *)view {
    
    
    
}


//set up fire fly
-(void)setUpFireFly
{
    playerSpeed = 0;
    playerAcceleration = 0;
    playerFriction = 0.95f;
    Firefly *fireFly = [[Firefly alloc]init];
    
    //fireFly.shielded = true;
    fireFly.position =CGPointMake(CGRectGetMidX(self.frame),50);
    [self addChild:fireFly];
}


-(void)setUpObstacle
{
    //start initialize obstacle from middle of the screen
    float current_pos = 0;
    float random_x=0;
    while (TRUE) {
        Obstacles *obs = [[Obstacles alloc]init];
        
        //random x position
        random_x = arc4random_uniform(CGRectGetWidth(self.frame) - level.obstacleDistance);
        random_x = random_x - CGRectGetWidth(self.frame)/2 ;
        obs.size = CGSizeMake(self.frame.size.width, 20.0);
        obs.position = CGPointMake(random_x,CGRectGetMidY(self.frame) + current_pos);
        obs.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:obs.size];
        obs.physicsBody.categoryBitMask = movingShapeCategory;
        obs.physicsBody.contactTestBitMask = playerCategory;
        obs.physicsBody.usesPreciseCollisionDetection = YES;
        obs.physicsBody.collisionBitMask = collisionBitMask;
        obs.physicsBody.dynamic = NO;
        
        [self addChild:obs];
        
        Obstacles *leftNode = [[Obstacles alloc]init];
        leftNode.position = CGPointMake(random_x +self.frame.size.width + level.obstacleDistance,CGRectGetMidY(self.frame) + current_pos);
        leftNode.size = CGSizeMake(self.size.width, 20.0);
        leftNode.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:leftNode.size];
        leftNode.physicsBody.categoryBitMask = movingShapeCategory;
        leftNode.physicsBody.contactTestBitMask = playerCategory;
        leftNode.physicsBody.usesPreciseCollisionDetection = YES;
        leftNode.physicsBody.collisionBitMask = collisionBitMask;
        leftNode.physicsBody.dynamic = NO;
        [self addChild:leftNode];
        current_pos += obstacleGap;
        
        if (current_pos >= CGRectGetMidY(self.frame)*3.0) {
            break;
        }
    }
    
}

/*
    add score label
 */

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
    passing = false;
}


/*
    get highest node
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

/*
    add obstacle
 */

-(void)addObstacle
{
    float random_x=0;
    random_x = arc4random_uniform(CGRectGetWidth(self.frame) - level.obstacleDistance);
    random_x = random_x - CGRectGetWidth(self.frame)/2 ;
    
    
    float lastNodePos = [self getHighestNodePos];
    
    
    Obstacles *rightNode = [[Obstacles alloc]init];
    rightNode.position = CGPointMake(random_x,lastNodePos + obstacleGap);
    rightNode.size = CGSizeMake(self.frame.size.width, 20.0);
    rightNode.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:rightNode.size];
    rightNode.physicsBody.categoryBitMask = movingShapeCategory;
    rightNode.physicsBody.contactTestBitMask = playerCategory;
    rightNode.physicsBody.usesPreciseCollisionDetection = YES;
    rightNode.physicsBody.collisionBitMask = collisionBitMask;
    rightNode.physicsBody.dynamic = NO;
    
    
    [self addChild:rightNode];
    
    Obstacles *leftNode = [[Obstacles alloc]init];
    leftNode.position = CGPointMake(random_x + self.frame.size.width + level.obstacleDistance,lastNodePos + obstacleGap);
    leftNode.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:leftNode.size];
    leftNode.size = CGSizeMake(self.frame.size.width, 20.0);
    leftNode.physicsBody.categoryBitMask = movingShapeCategory;
    leftNode.physicsBody.contactTestBitMask = playerCategory;
    leftNode.physicsBody.usesPreciseCollisionDetection = YES;
    leftNode.physicsBody.collisionBitMask =collisionBitMask;
    leftNode.physicsBody.dynamic = NO;
    
    [self addChild:leftNode];
    
    
}


/*
    update point label
 */
-(void)updatePointLabel
{
    point+=1;
    [GameData sharedGameData].score = point/2;
    scoreLabel.text = [ NSString stringWithFormat:@"%ld", [GameData sharedGameData].score];
    [level updateLevel:(int)[GameData sharedGameData].score];
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
        node.position = CGPointMake(node.position.x, node.position.y - timeSinceLast*level.speed);
        
        
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
                                    - timeSinceLast*movingSpeed);
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




-(void)checkCollision
{
    NSLog(@"Contact");
    
    [GameData sharedGameData].highScore = MAX([GameData sharedGameData].score,
                                              [GameData sharedGameData].highScore);
    
    [[GameData sharedGameData] save];
    [[GameData sharedGameData] reset];
    
    
    
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
}



@end
