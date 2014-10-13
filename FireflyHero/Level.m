//
//  Level.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-7.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "Level.h"

@implementation Level
@synthesize level;
@synthesize heroX;
@synthesize heroY;
@synthesize lightPenalty;
@synthesize maxScore;
@synthesize goldScore;
@synthesize background;
@synthesize lights;
@synthesize stars;
@synthesize spiders;
@synthesize tips;
@synthesize spikes;
@synthesize fans;
@synthesize flowers;

- (void)dealloc {
    [level release];
    [background release];
    [lights release];
    [stars release];
    [spiders release];
    [tips release];
    [spikes release];
    [fans release];
    [flowers release];
    [super dealloc];
}
@end
