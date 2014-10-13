//
//  FlowerSprite.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-17.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "cocos2d.h"
#import "Model.h"

@interface FlowerSprite : CCSprite
{
    CCSpriteBatchNode *_batchNode;
    int _interval;
}

@property (nonatomic,readonly) NSMutableArray *flowerBalls;

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode;
- (void)animationWithInterval:(int)interval delay:(int)delay;

@end
