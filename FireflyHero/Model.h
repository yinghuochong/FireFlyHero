//
//  Model.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-7.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>

//游戏中用到的 模型的基类
@interface Model : NSObject
@property (nonatomic,assign)float x;
@property (nonatomic,assign)float y;
@end

//星星
@interface Star : Model 
@end

//灯泡
@interface Light : Model
@property (nonatomic,assign) int lightType;
@property (nonatomic,assign) int interval;
@end

//提示
@interface Tip : Model
@property (nonatomic,retain)NSString *name;
@end

//耙子
@interface Spike : Model 
@property (nonatomic,assign) int length;
@property (nonatomic,assign) int angle;
@end

//蜘蛛
@interface Spider : Model 
@property (nonatomic,assign) int speed;
@property (nonatomic,retain) NSArray *points;
@end

//风扇
@interface Fan : Model 
@property (nonatomic,assign) int angle;
@end

//花
@interface Flower : Model 
@property (nonatomic,assign)int interval;
@property (nonatomic,assign) int delay;
@end



