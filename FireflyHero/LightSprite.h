//
//  LightSprite.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-13.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "cocos2d.h"
#import "Model.h"
@interface LightSprite : CCSprite<CCTargetedTouchDelegate> 
{
    id _target;
    SEL _action;
    CCSpriteBatchNode *_batchNode;
    int _interval;
}

@property (nonatomic,assign)int buttonType;
@property (nonatomic,readonly)CCSprite *onlightSprite;

@property (nonatomic,readonly)CCSprite *crackSprite;
@property (nonatomic,readonly)CCSprite *onCrackSprite;
@property (nonatomic,assign)Boolean enable;

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode light:(Light *)light target:(id)_t selector:(SEL)_s;

- (void)lightOn;
- (void)lightOff;

- (void)animationBlast;
- (void)animationScale;
@end
