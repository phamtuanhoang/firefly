//
//  GameData.m
//  MatchingRush
//
//  Created by hoangpham on 12/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "GameData.h"
#import "Common.h"

@implementation GameData

@synthesize isMusicON;


+ (instancetype)sharedGameData {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    return sharedInstance;
}


-(void)reset
{
    self.score = 0;
}

-(void)setVolume
{
    if (!self.isMusicON) {
        self.isMusicON = true;
    }else{
        self.isMusicON = false;
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"OnOffSound_Notification"
     object:self];
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeDouble:self.highScore forKey: DataHighScoreKey];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        _highScore = [decoder decodeDoubleForKey: DataHighScoreKey];
    }
    return self;
}

+(NSString*)filePath
{
    static NSString* filePath = nil;
    if (!filePath) {
        filePath =
        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
         stringByAppendingPathComponent:@"gamedata"];
    }
    return filePath;
}

+(instancetype)loadInstance
{
    NSData* decodedData = [NSData dataWithContentsOfFile: [GameData filePath]];
    if (decodedData) {
        GameData* gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        return gameData;
    }
    
    return [[GameData alloc] init];
}

-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: self];
    [encodedData writeToFile:[GameData filePath] atomically:YES];
}
@end
