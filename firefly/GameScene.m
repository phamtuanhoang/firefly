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

@implementation GameScene
{
    Firefly *fireFly;
    
    /* not used (daniel)
     BOOL isMovedFireFly;
     BOOL moveLeftRight;
     */
    /* special boolean variable for checking touch-hold event */
    BOOL gTouchDown;
    
    
    float playerSpeed;					/* current movement speed */
    float playerAcceleration;			/* acceleration to boost speed */
    float playerFriction;				/* friction slow down speed when not touched */
    
    NSInteger *nodeCount;
    NSMutableArray *obstaclesArray;
    int totalNodeCount;
    
    //label
    SKLabelNode *scoreLabel;
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
    SKPhysicsBody *borders = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borders;
    
    self.physicsBody.friction = 0.f;
    
    [self setUpFireFly];
    [self setUpObstacle];
}

-(void)setUpObstacle
{
    //start initialize obstacle from middle of the screen
    float current_pos = 0;
    float random_x=0;
    totalNodeCount = 0;
    obstaclesArray= [[NSMutableArray alloc] init];
    while (TRUE) {
        Obstacles *obs = [[Obstacles alloc]init];
        
        //random x position
        random_x = arc4random_uniform(CGRectGetWidth(self.frame) - obstacleDistance);
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
        leftNode.position = CGPointMake(random_x +self.frame.size.width + obstacleDistance,CGRectGetMidY(self.frame) + current_pos);
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

-(void)setUpFireFly
{
    
    // setup speed parameters
    playerSpeed = 0;
    playerAcceleration = 0;
    playerFriction = 0.95f; 		// a value between 0.0 ~ 1.0
    
    // setup object
    fireFly = [[Firefly alloc]init];
    
    fireFly.position =CGPointMake(CGRectGetMidX(self.frame),
                                  50);
    fireFly.size = CGSizeMake(20.0, 20.0);
    fireFly.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:fireFly.size];
    
    fireFly.physicsBody.categoryBitMask = playerCategory;
    fireFly.physicsBody.contactTestBitMask = movingShapeCategory ;
    fireFly.physicsBody.collisionBitMask = collisionBitMask ;
    fireFly.physicsBody.dynamic = YES;
    fireFly.physicsBody.usesPreciseCollisionDetection = YES;
    //isMovedFireFly = false;
    //moveLeftRight = false;
    [self addChild:fireFly];
    //[self setUpLeftRightBound];
}

-(void)setUpLeftRightBound
{
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(10, self.scene.size.height)];
    left.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:left.size];
    left.position = CGPointMake(CGRectGetMidX(self.frame)/2,50);
    left.physicsBody.categoryBitMask = movingShapeCategory;
    left.physicsBody.contactTestBitMask = playerCategory;
    left.physicsBody.usesPreciseCollisionDetection = YES;
    left.physicsBody.collisionBitMask = collisionBitMask;
    left.physicsBody.dynamic = NO;
    
    [self addChild:left];
}

-(void)addObstacle
{
    float random_x=0;
    random_x = arc4random_uniform(CGRectGetWidth(self.frame) - obstacleDistance);
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
    leftNode.position = CGPointMake(random_x + self.frame.size.width +obstacleDistance,lastNodePos + obstacleGap);
    leftNode.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:leftNode.size];
    leftNode.size = CGSizeMake(self.frame.size.width, 20.0);
    leftNode.physicsBody.categoryBitMask = movingShapeCategory;
    leftNode.physicsBody.contactTestBitMask = playerCategory;
    leftNode.physicsBody.usesPreciseCollisionDetection = YES;
    leftNode.physicsBody.collisionBitMask =collisionBitMask;
    leftNode.physicsBody.dynamic = NO;
    
    [self addChild:leftNode];
    
    
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
    // set touch down to true
    gTouchDown = true;

    /* Determine movement direction */
    if( location.x <= self.frame.size.width / 2 ) {
        // move left set acceleration to negative
        playerAcceleration = - 1;
    }
    else {
        // move right set acceleration to negative
        playerAcceleration = 1;
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
        node.position = CGPointMake(node.position.x, node.position.y
                                    - timeSinceLast*movingSpeed);
        if ((node.position.y < 0)) {
            [node removeFromParent];
            [self addObstacle];
            //add a replace node at the back
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
        playerSpeed *= playerFriction;
        
        // apply new instant boosting acceleration (* if any by Touch *)
        // speed is boosted by instant acceleration
        if( gTouchDown == true )
        {
            playerSpeed += playerAcceleration;
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
        NSLog(@"Touch obs");
    }
    
    // 2
    //    if ((firstBody.categoryBitMask & playerCategory) != 0 &&
    //        (secondBody.categoryBitMask & leftBorder) != 0)
    //    {
    //        NSLog(@"Touch border");
    //    }
}



@end
