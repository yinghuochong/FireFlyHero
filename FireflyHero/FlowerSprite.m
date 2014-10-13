//
//  FlowerSprite.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-17.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "FlowerSprite.h"
#import "CCAnimation+Helper.h"
#import "SimpleAudioEngine.h"
#import "Global.h"

@implementation FlowerSprite
@synthesize flowerBalls = _flowerBalls;
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode
{
    self = [super initWithSpriteFrameName:@"Flower3.png"];
    if (self) {
        _batchNode = batchNode;
        _flowerBalls = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}
//首先延迟
- (void)animationWithInterval:(int)interval delay:(int)delay
{
    CCMoveTo *moveto1 = [[CCMoveTo alloc] initWithDuration:delay position:self.position];
    CCCallFunc *callfunc = [[CCCallFunc alloc] initWithTarget:self selector:@selector(delayFinished)];
    [self runAction:[CCSequence actions:moveto1,callfunc, nil]];
    [moveto1 release];
    [callfunc release];
    _interval = interval;
}
//延迟结束 开始发射动作  每隔interval 发射一个
- (void)delayFinished
{
    CCAnimation *animation = [CCAnimation animationWithFrame:@"Flower" frameCount:5 delay:0.1 firstNum:1];
    CCAnimate *action = [[CCAnimate alloc] initWithAnimation:animation];
    
    CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration:_interval position:self.position];
    CCCallFunc *callfunc = [[CCCallFunc alloc] initWithTarget:self selector:@selector(animationFinished)];
    
    CCRepeatForever *repeat = [[CCRepeatForever alloc] initWithAction:[CCSequence actions:action,callfunc,moveto, nil]];
    
    [action release];
    [moveto release];
    [callfunc release];
    [self runAction:repeat];
    [repeat release];

}
//发射动作结束 生成一个子弹
- (void)animationFinished
{
    if (g_isSoundOn) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"FlowerPop.mp3"];
    }
    CCSprite *flowerBall = [[CCSprite alloc] initWithSpriteFrameName:@"FlowerBall1.png"];
    flowerBall.position = ccp(self.position.x, self.position.y+15);
    [_flowerBalls addObject:flowerBall];
    [_batchNode addChild:flowerBall z:self.zOrder-1];
    [flowerBall release];
    CCAnimation *animation = [CCAnimation animationWithFrame:@"FlowerBall" frameCount:8 delay:0.1 firstNum:1];
    CCAnimate *action = [[CCAnimate alloc] initWithAnimation:animation];
    CCRepeat *repeat = [[CCRepeat alloc] initWithAction:action times:3];
    [action release];
    CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration:2.5 position:ccp(self.position.x, 320)];
    CCSpawn *spawn = [CCSpawn actions:repeat,moveto, nil];
    [moveto release];
    [repeat release];
    CCCallFuncN *callFunc = [[CCCallFuncN alloc] initWithTarget:self selector:@selector(removeFlowerBall:)];
    [flowerBall runAction:[CCSequence actions:spawn,callFunc, nil]];
     [callFunc release];
}
//子弹出屏幕时候移除之
- (void)removeFlowerBall:(CCSprite *)flowerBall
{
    [_flowerBalls removeObject:flowerBall];
    [flowerBall removeFromParentAndCleanup:YES];
}
@end