//
//  Level.h
//  firefly
//
//  Created by hoangpham on 22/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject


@property (assign, nonatomic) long score;
@property (assign, nonatomic) long level;
@property (assign, nonatomic) long speed;
@property (assign, nonatomic) long obstactGap;
@property (assign, nonatomic) float obstacleDistance;




-(void)resetSpeed;
-(void)updateLevel:(int)currentScore;

@end
