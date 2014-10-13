//
//  FireflySprite.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-13.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "FireflySprite.h"
#import "CCAnimation+Helper.h"
#import "SimpleAudioEngine.h"

@implementation FireflySprite

@synthesize delegate;
@synthesize collideSprite=_collideSprite;
@synthesize fireflyShadow=_fireflyShadow;

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode postion:(CGPoint)p
{
    self = [super initWithSpriteFrameName:@"Firefly1.png"];
    if (self) {
        _batchNode = batchNode;
        self.rotation = 90.0f;
        self.anchorPoint = ccp(0.5, 0.5);
        self.position = p;
        self.opacity = 255;
        
        _collideSprite = [[CCSprite alloc] initWithSpriteFrameName:@"Firefly1.png"];
        _collideSprite.position = p;
        [batchNode addChild:_collideSprite z:0];
        _collideSprite.anchorPoint = ccp(0.5, 0.5);
        _collideSprite.opacity = 1;
        _collideSprite.scale = 0.1;
        _collideSprite.rotation = self.rotation;
        [_collideSprite release];
        
       _fireflyShadow = [[CCSprite alloc] initWithSpriteFrameName:@"FireflyShadow1.png"];
        _fireflyShadow.position = ccp(p.x, p.y-15);
        _fireflyShadow.rotation = 90.0f;
        _fireflyShadow.anchorPoint = ccp(0.5, 0.5);
        [batchNode addChild:_fireflyShadow z:199];
        [_fireflyShadow release];
    }
    return self;
}

//开始一关的时候 萤火虫触角在动
- (void)animationFeeler
{
    CCAnimation *animation = [CCAnimation animationWithFrame:@"Firefly" frameCount:4 delay:0.1 firstNum:1];
    CCAnimate *action = [[CCAnimate alloc] initWithAnimation:animation restoreOriginalFrame:YES];
    //CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration:0.1 position:ccp(self.position.x, self.position.y+5)];
    CCRepeatForever *action2 = [[CCRepeatForever alloc] initWithAction:action];
    [self runAction:action2];
    [action release];
    [action2 release];
    
    animation = [CCAnimation animationWithFrame:@"FireflyShadow" frameCount:4 delay:0.1 firstNum:1];
    action = [[CCAnimate alloc] initWithAnimation:animation restoreOriginalFrame:YES];
    action2 = [[CCRepeatForever alloc] initWithAction:action];
    [_fireflyShadow runAction:action2];
    [action release];
    [action2 release];
}

//萤火虫运动中自身的翅膀和触角动画
- (void)animationWingsAndFeeler
{
    CCAnimation *animation = [CCAnimation animationWithFrame:@"Firefly" frameCount:4 delay:0.05 firstNum:1];
    CCAnimate *action = [[CCAnimate alloc] initWithAnimation:animation restoreOriginalFrame:NO];
    
    CCAnimation *animation2 = [CCAnimation animationWithFrame:@"Firefly" frameCount:5 delay:0.05 firstNum:4];
    CCAnimate *action2 = [[CCAnimate alloc] initWithAnimation:animation2 restoreOriginalFrame:NO];
    CCRepeatForever *repeatAction = [[CCRepeatForever alloc] initWithAction:[CCSpawn actions:action ,action2, nil]];
    [action release];
    [action2 release];
    
    [self runAction:repeatAction];
    [repeatAction release];
    
    animation = [CCAnimation animationWithFrame:@"FireflyShadow" frameCount:4 delay:0.05 firstNum:1];
    action = [[CCAnimate alloc] initWithAnimation:animation restoreOriginalFrame:NO];
    
    animation2 = [CCAnimation animationWithFrame:@"FireflyShadow" frameCount:5 delay:0.05 firstNum:4];
    action2 = [[CCAnimate alloc] initWithAnimation:animation2 restoreOriginalFrame:NO];
    repeatAction = [[CCRepeatForever alloc] initWithAction:[CCSpawn actions:action ,action2, nil]];
    [action release];
    [action2 release];
    
    [_fireflyShadow runAction:repeatAction];
    [repeatAction release];
}

//萤火虫运动动画
- (void)animationWithMoveTo : (CGPoint)point :(float)duration : (float) angle 
{
    CCRotateTo *rotateTo = [[CCRotateTo alloc] initWithDuration:0.3f angle:angle];
    CCMoveTo *moveTo = [[CCMoveTo alloc] initWithDuration:duration position:point];
    [self runAction:rotateTo];
    [self runAction:moveTo];
    [rotateTo release];
    [moveTo release];
    
    CCCallFunc *callFunc = [[CCCallFunc alloc] initWithTarget:self selector:@selector(moveFinished)];
    rotateTo = [[CCRotateTo alloc] initWithDuration:0.3f angle:angle];
    moveTo = [[CCMoveTo alloc] initWithDuration:duration position:ccp(point.x, point.y-15.0f)];
    [_fireflyShadow runAction:rotateTo];
    CCSequence *sequece = [CCSequence actions:moveTo,callFunc, nil];
    sequece.tag = 11111;
    [_fireflyShadow runAction:sequece];
    [callFunc release];
    [rotateTo release];
    [moveTo release];
}

//萤火虫移动到一个灯泡结束的时候
- (void)moveFinished
{
    [self stopAllanimation];
    [self animationFeeler];
}

//撞晕的动画
- (void)animationHalo
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([[ud objectForKey:@"soundStatu"] intValue])
        [[SimpleAudioEngine sharedEngine] playEffect:@"Chirp.mp3"];
    
    CCSprite *holeSprite = [[CCSprite alloc] initWithSpriteFrameName:@"FireflyHalo1.png"];
    holeSprite.position = self.position;
    holeSprite.rotation = self.rotation-90;
    [_batchNode addChild:holeSprite z:1000];
    [holeSprite release];
    CCAnimation *animation = [CCAnimation animationWithFrame:@"FireflyHalo" frameCount:6 delay:0.08 firstNum:1];
    CCAnimate *action = [[CCAnimate alloc] initWithAnimation:animation];
    CCRepeatForever *repeat = [[CCRepeatForever alloc] initWithAction:action];
    [holeSprite runAction:repeat];
    [action release];
    [repeat release];
    
    CCSprite *eyeSprite = [[CCSprite alloc] initWithSpriteFrameName:@"FireflyEyes1.png"];
    eyeSprite.position = ccp(self.position.x+2, self.position.y);
    eyeSprite.rotation = self.rotation;
    [_batchNode addChild:eyeSprite z:1000];
    [eyeSprite release];
    animation = [CCAnimation animationWithFrame:@"FireflyEyes" frameCount:6 delay:0.1 firstNum:1];
    action = [[CCAnimate alloc] initWithAnimation:animation];
    CCRepeat *repeat1 = [[CCRepeat alloc] initWithAction:action times:3];
    CCCallFunc *callfunc = [[CCCallFunc alloc] initWithTarget:self selector:@selector(holeFinished)];
    [eyeSprite runAction:[CCSequence actions:repeat1,callfunc, nil]];
    [callfunc release];
    [action release];
    [repeat1 release];
}

//执行代理方法 重新开始
- (void)holeFinished
{
    [delegate fireflyHoloAnimationFinished];
}

//停止萤火虫的动画
- (void)stopAllanimation
{
    [self stopAllActions];
    [_fireflyShadow stopAllActions];
}

- (void)dealloc {
    [super dealloc];
}
@end
