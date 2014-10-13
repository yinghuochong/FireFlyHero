//
//  LevelSelectLayer.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-5.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LevelSelectLayer : CCLayer<CCTargetedTouchDelegate>
{
    CCSpriteBatchNode *_batchNode;
    CGPoint lastPostion;
    CGPoint oldMenuPosition;
    CCLayer *menuLayer;
}
+ (id)scene;
@end
