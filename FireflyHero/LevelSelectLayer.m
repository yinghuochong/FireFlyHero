//
//  LevelSelectLayer.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-5.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "LevelSelectLayer.h"
#import "StartLayer.h"
#import "LevelSelectButton.h"
#import "CCButton.h"
#import "GameLayer.h"
#import "LevelParser.h"
#import "Global.h"

@implementation LevelSelectLayer
+ (id)scene
{
    CCScene *scene = [[CCScene alloc] init];
    LevelSelectLayer *layer = [[LevelSelectLayer alloc] init];
    [scene addChild:layer];
    [layer release];
    return [scene autorelease];
}

- (id)init
{
    self = [super init];
    if (self) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *bgSprite = [[CCSprite alloc] initWithFile:@"Bg-LevelSelector.png"];
        bgSprite.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
        bgSprite.opacity = 220;
        [self addChild:bgSprite];
        [bgSprite release];
        
        //关卡选择
        menuLayer = [[CCLayer alloc] init];
        menuLayer.anchorPoint = ccp(0.5f, 0.5f);
        menuLayer.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
        
        _batchNode = [[CCSpriteBatchNode alloc] initWithFile:@"LevelSelectorElements.png" capacity:0];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LevelSelectorElements.plist"];
        [menuLayer addChild:_batchNode];
        [_batchNode release];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        LevelParser *parser = [LevelParser sharedLevelParser];
         //获取本地游戏记录 
        for (int i=0; i<parser.levles.count; i++) {
            LevelSelectButtonType buttonType = [[ud objectForKey:[NSString stringWithFormat:@"%d",i+1]] intValue];
            LevelSelectButton *button = [[LevelSelectButton alloc] initWithButtonType:buttonType text:[NSString stringWithFormat:@"%d",i+1] target:self selector:@selector(levelSelected:)];
            button.tag = i;
            button.position = ccp((i%5)*80.0f-160.0f, 140.0f-(i/5+1)*70.0f);
            [menuLayer addChild:button];
            [button release];
        }
        [self addChild:menuLayer];
        [menuLayer release];
           
        //遮罩
        CCSprite *overlaySprite = [[CCSprite alloc] initWithFile:@"LevelSelectorOverlay.png"];
        overlaySprite.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
        [self addChild:overlaySprite];
        [overlaySprite release];
        
        //返回按钮
        CCButton *button = [[CCButton alloc] initFromNormalImage:@"Button-Back.png" selectedImage:@"Button-Back-Pressed.png" target:self selector:@selector(backButtonClick)];
        button.position = ccp(button.contentSize.width/2.0f+5.0f, winSize.height- button.contentSize.width/2.0f-5.0f);
        [self addChild:button];
        [button release];
    }
    return self;
}

- (void)levelSelected:(LevelSelectButton *)button
{
    CCTransitionFade *translation = [[CCTransitionFade alloc] initWithDuration:0.5f scene:[GameLayer scene:button.text]];
    [[CCDirector sharedDirector] replaceScene:translation];
    [translation release];
}

- (void)backButtonClick
{
    CCTransitionSlideInL *translation = [[CCTransitionSlideInL alloc] initWithDuration:0.3f scene:[StartLayer scene]];
    [[CCDirector sharedDirector] replaceScene:translation];
    [translation release];
}

#pragma mark - --touch 相关
#if 1
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"touch began");
    lastPostion = [touch locationInView:[touch view]];
    oldMenuPosition = menuLayer.position;
    return YES;
    
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [touch locationInView:[touch view]];
    
    float distance = (currentPoint.x - lastPostion.x);
    if (oldMenuPosition.y +distance< 160 || oldMenuPosition.y +distance>1000) {
        distance = 0;
    }
    menuLayer.position= ccp(oldMenuPosition.x, oldMenuPosition.y +distance );
    lastPostion = currentPoint;
    oldMenuPosition = menuLayer.position;
}

- (void)onEnter
{
    [super onEnter];
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-129 swallowsTouches:NO];
}

- (void)onExit
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}
#endif
- (void)dealloc
{
//    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
//    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [super dealloc];
}

@end