//
//  LevelCompletedLayer.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-15.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "cocos2d.h"

@interface LevelCompletedLayer : CCColorLayer

- (id)initWithLevel:(NSString *)level currentScore:(float)currentScore maxScore:(float)maxScore goldScore:(float)goldScore menuButtons:(NSArray *)array;
- (void)animationLayer;

@end
