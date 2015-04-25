//
//  GameData.h
//  MatchingRush
//
//  Created by hoangpham on 12/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject <NSCoding>

@property (assign, nonatomic) long score;

@property (assign, nonatomic) long highScore;
@property (assign, nonatomic) BOOL isMusicON;

+(instancetype)sharedGameData;
-(void)reset;
-(void)save;
-(void)setVolume;

@end
