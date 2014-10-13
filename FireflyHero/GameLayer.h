//
//  GameLayer.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-5.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelParser.h"
#import "FireflySprite.h"

@interface GameLayer : CCLayer <FireflySpriteDelegate>
{
    CCSpriteBatchNode *batchNode;
    FireflySprite *firefly;
    CCSprite *scoreSprite;
    
    NSMutableArray *stars;      //星星
    NSMutableArray *lights;     //灯泡
    NSMutableArray *spikes;     //耙子
    NSMutableArray *spiders;    //蜘蛛
    NSMutableArray *fans;       //风扇
    NSMutableArray *flowers;    //花
    
    //分数相关
    float maxScore;
    float scoreOfPerStar;
    float goldScore;
    float lightPenalty;
    float currentScore;
    
    LevelParser *parser;
    CGPoint destPosition;  //临时的目标位置，进入风扇区域时用
    
    bool isInfan;
}

@property (atomic,retain) NSString *currentLevel; 

+ (id)scene : (NSString *)level;
- (id)initWithLevel:(NSString *)level;
- (void)loadGame;
- (void)fail;
@end
