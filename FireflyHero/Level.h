//
//  Level.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-7.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface Level : NSObject

@property (nonatomic,retain) NSString *level;       //第几关
@property (nonatomic,assign) int heroX;   //萤火虫的位置
@property (nonatomic,assign) int heroY;
@property (nonatomic,assign) int lightPenalty;      //每多按一次灯泡 惩罚的分数
@property (nonatomic,assign) int maxScore;          //该关最高分
@property (nonatomic,assign) int goldScore;         //得多少分会给金叶子
@property (nonatomic,retain) NSString *background;  //所用的背景

@property (nonatomic,retain) NSMutableArray *lights;        //所有星星所在的灯泡
@property (nonatomic,retain) NSMutableArray *stars;           //所有星星所在的位置
@property (nonatomic,retain) NSMutableArray *spiders;       //蜘蛛s
@property (nonatomic,retain) NSMutableArray *tips;             //提示s
@property (nonatomic,retain) NSMutableArray *spikes;        //耙子s

@property (nonatomic,retain) NSMutableArray *fans;      //风扇
@property (nonatomic,retain) NSMutableArray *flowers;   //花

@end

