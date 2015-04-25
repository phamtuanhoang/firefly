//
//  Item.m
//  firefly
//
//  Created by hoangpham on 25/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "Item.h"
#import "Common.h"

@implementation Item




-(instancetype)init
{
    self = [super initWithImageNamed:@"circlePurple2"];
    {
        self.name = powerUpItem;
        self.size = CGSizeMake(20.0, 20.0);
        self.physicsBody.dynamic = NO;
        self.physicsBody =[SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.categoryBitMask = itemCategory;
        self.physicsBody.contactTestBitMask = playerCategory;
        self.physicsBody.dynamic = NO;
    }
    return self;
}



@end
