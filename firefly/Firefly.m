//
//  Firefly.m
//  firefly
//
//  Created by hoangpham on 17/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "Firefly.h"
#import "Common.h"

@implementation Firefly
-(instancetype)init
{
    self = [super initWithImageNamed:@"cicleBlue"];
    {
        self.name = fireflyName;
        self.physicsBody.dynamic = NO;


    }
    return self;
}
@end
