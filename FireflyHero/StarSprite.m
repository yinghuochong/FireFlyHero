
//
//  StarSprite.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-13.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "StarSprite.h"
#import "CCAnimation+Helper.h"

@implementation StarSprite

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode postion:(CGPoint)p
{
    self = [super initWithSpriteFrameName:@"Star1.png"];
    if (self) {
        self.position = p;
        _batchNode = batchNode;
    }
    return  self;
}

- (void)animationBlink
{
    //星星闪烁效果
    CCAnimation *animation = [CCAnimation animationWithFrame:@"Star" frameCount:4 delay:0.1f firstNum:1];
    CCAnimate *action = [[CCAnimate alloc] initWithAnimation:animation restoreOriginalFrame:NO];
    CCRepeatForever *action2 = [[CCRepeatForever alloc] initWithAction:action];
    [self runAction:action2];
    [action release];
    [action2 release];
}

//将星星从屏幕上移除 并且伴随爆炸效果
- (void)removefromGamelayerWithScorePostion:(CGPoint)scorePostion
{
    //显示星星 爆炸效果
    CCSprite *sprite = [[CCSprite alloc] initWithSpriteFrameName:@"StarBurst1.png"];
    sprite.position = self.position;
    [_batchNode addChild:sprite];
    [sprite release];
    sprite.scale = 1.0;
    
    CCAnimation *animation =[CCAnimation animationWithFrame:@"StarBurst" frameCount:5 delay:0.05 firstNum:1];
    CCAnimate *action = [[CCAnimate alloc] initWithAnimation:animation];
    CCCallFuncN *action2 = [[CCCallFuncN alloc] initWithTarget:self selector:@selector(starBurst:)];
    [sprite runAction:[CCSequence actions:action,action2, nil]];
    [action release];
    [action2 release];
    
    //将星星移除，加一个move到score的动画
    self.scale = 0.8;
    CCRotateTo *rotateTo = [[CCRotateTo alloc] initWithDuration:0.5 angle:3600];
    [self runAction:rotateTo];
    [rotateTo release];
    CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration:0.5 position:scorePostion];
    CCCallFuncN *callAction = [[CCCallFuncN alloc] initWithTarget:self selector:@selector(moveFinish:)];
    [self runAction:[CCSequence actions:moveto,callAction, nil]];
    [moveto release];
    [callAction release];
}

- (void)moveFinish:(CCSprite *)star
{
    [star removeFromParentAndCleanup:YES];
}

- (void)starBurst:(CCSprite *)starBurst
{
    [starBurst removeFromParentAndCleanup:YES];
}

@end
