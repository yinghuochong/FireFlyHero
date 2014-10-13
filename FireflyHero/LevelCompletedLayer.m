//
//  LevelCompletedLayer.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-15.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "LevelCompletedLayer.h"
#import "CCTextButton.h"
#import "LevelSelectButton.h"
#import "Global.h"
#import "LevelParser.h"

@implementation LevelCompletedLayer

- (id)initWithLevel:(NSString *)level currentScore:(float)currentScore maxScore:(float)maxScore goldScore:(float)goldScore menuButtons:(NSArray *)array
{
    self = [super initWithColor:ccc4(0, 0, 0, 0)];
    if (self) {
        
        LevelParser *parser = [LevelParser sharedLevelParser];
    
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        LevelSelectButtonType currentLevelType = [[ud objectForKey:[NSString stringWithFormat:@"%d",[level intValue]]] intValue];
        LevelSelectButtonType nextLevelType = [[ud objectForKey:[NSString stringWithFormat:@"%d",[level intValue]+1]] intValue];
        if (currentLevelType == ButtonTypeUnlocked && nextLevelType!= ButtonTypeLocked) {
            g_skipLevelNum --;
        }
        [ud setObject:[NSString stringWithFormat:@"%d",currentScore>=goldScore?ButtonTypePassedLeaf:ButtonTypePassed] forKey:[NSString stringWithFormat:@"%d",[level intValue]]];
        if (nextLevelType == ButtonTypeLocked) {
            [ud setObject:[NSString stringWithFormat:@"%d",ButtonTypeUnlocked] forKey:[NSString stringWithFormat:@"%d",[level intValue]+1]];
        }
        
        CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"LevelCompleted.png"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LevelCompleted.plist"];
        [self addChild:batchNode];

        //背景
        CCSprite *bgSprite = [[CCSprite alloc] initWithSpriteFrameName:@"MainWindow.png"];
        [batchNode addChild:bgSprite];
        [bgSprite release];
        //关卡
        CCLabelBMFont *lableText = [[CCLabelBMFont alloc] initWithString:level fntFile:@"roundawrite-outline.fnt"];
        lableText.position = ccp(30,35);
        lableText.scale = 0.8;
        lableText.anchorPoint = ccp(0.0f, 0.5f);
        [self addChild:lableText];
        [lableText release];
        
        //分数条
        CCSprite *scoreSprite = [[CCSprite alloc] initWithSpriteFrameName:@"ScoreBarLarge.png"];
        scoreSprite.position = ccp(-2-scoreSprite.contentSize.width/2.0f, -4.5);
        scoreSprite.anchorPoint = ccp(0.0, 0.5);
        scoreSprite.scaleX = 0.01;
        scoreSprite.scaleY = 1.15;
        
        //金叶子
        CGPoint leafPosition = ccp(scoreSprite.position.x+scoreSprite.contentSize.width-25.0f,0.0f);
        CCSprite *leafDisableSprite = [[CCSprite alloc] initWithSpriteFrameName:@"LeafDisabledLarge.png"];
        [batchNode addChild:leafDisableSprite z:10];
        leafDisableSprite.position = leafPosition;
        [leafDisableSprite release];
        
        CCSprite *leafEnableSprite = [[CCSprite alloc] initWithSpriteFrameName:@"LeafEnabledLarge.png"];
        [batchNode addChild:leafEnableSprite z:11];
        leafEnableSprite.opacity = 0;
        leafEnableSprite.position = leafDisableSprite.position;
        [leafEnableSprite release];
        
        if (currentScore>=goldScore) {
            CCScaleTo *scaleto = [[CCScaleTo alloc] initWithDuration:1.0f scaleX:1.0f scaleY:scoreSprite.scaleY];
            [scoreSprite runAction:scaleto];
            [scaleto release];
            
            float length = leafEnableSprite.position.x - scoreSprite.position.x;
            CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration: length/scoreSprite.contentSize.width position:leafEnableSprite.position];
            CCFadeTo *fadeto = [[CCFadeTo alloc] initWithDuration:0.001 opacity:255];
            CCScaleTo *scaleto1 = [[CCScaleTo alloc] initWithDuration:0.5 scale:2.0] ;
            CCScaleTo *scaleto2 = [[CCScaleTo alloc] initWithDuration:0.01 scale:1.0] ;
            [leafEnableSprite runAction:[CCSequence actions:moveto,fadeto,scaleto1,scaleto2,nil]];
            [moveto release];
            [fadeto release];
            [scaleto1 release];
            [scaleto2 release];
        }else{
            CCScaleTo *scaleto = [[CCScaleTo alloc] initWithDuration:1.0f scaleX:currentScore/maxScore scaleY:scoreSprite.scaleY];
            [scoreSprite runAction:scaleto];
            [scaleto release];
        }
        [batchNode addChild:scoreSprite z:9];
        [scoreSprite release];
        
        //菜单
        int gap = 0;
        int y = -55;
        CCTextButton *mainButton = (CCTextButton *)[array objectAtIndex:0];
        mainButton.anchorPoint = ccp(0.0f, 0.5f);
        mainButton.position = ccp(gap+mainButton.contentSize.width/2.0f-bgSprite.contentSize.width/2.0f ,y);
        [self addChild:mainButton];
        
        if ([level intValue] != parser.levles.count) {
            CCTextButton *nextButton = (CCTextButton *)[array objectAtIndex:2];
            nextButton.anchorPoint = ccp(0.0f, 0.5f);
            nextButton.position = ccp(gap*3+nextButton.contentSize.width*5.0f/2.0f-bgSprite.contentSize.width/2.0f ,y);
            [self addChild:nextButton];
        }
        CCTextButton *replayButton = (CCTextButton *)[array objectAtIndex:1];
        replayButton.anchorPoint = ccp(0.0f, 0.5f);
        replayButton.position = ccp(gap*2+replayButton.contentSize.width*3.0f/2.0f-bgSprite.contentSize.width/2.0f ,y);
        [self addChild:replayButton];
    }
    return self;
}

- (void)animationLayer
{
    CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration:1.5 position:ccp(0.0f, 0.0f)];
    CCEaseBackInOut *bounceOut = [[CCEaseBackInOut alloc] initWithAction:moveto];
    [self runAction:bounceOut];
    [moveto release];
    [bounceOut release];
}

- (void)dealloc {
    [super dealloc];
}

@end
