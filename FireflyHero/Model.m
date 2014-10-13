//
//  Model.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-7.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "Model.h"

@implementation Model
@synthesize x;
@synthesize y;
@end

@implementation Star
@end

@implementation Light
@synthesize lightType;
@synthesize interval;
@end

@implementation Tip
@synthesize name;
- (void)dealloc {
    [name release];
    [super dealloc];
}
@end

@implementation Spike
@synthesize length;
@synthesize angle;
@end

@implementation Spider
@synthesize speed;
@synthesize points;
- (void)dealloc {
    [points release];
    [super dealloc];
}
@end

@implementation Fan
@synthesize angle;
@end

@implementation Flower

@synthesize interval;
@synthesize delay;

@end
