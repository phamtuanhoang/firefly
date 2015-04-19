//
//  Item.m
//  firefly
//
//  Created by hoangpham on 19/4/15.
//  Copyright (c) 2015 hoangpham. All rights reserved.
//

#import "Item.h"
#import "Common.h"

@implementation Item



-(instancetype)init
{
    self = [super initWithImageNamed:@"circlePurple2"];
    {
        self.name = itemName;
        self.physicsBody.dynamic = NO;
    }
    return self;
}


@end
