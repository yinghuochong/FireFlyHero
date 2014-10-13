//
//  LevelSelectButton.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-6.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    ButtonTypePassedLeaf,
    ButtonTypeLocked,
    ButtonTypeUnlocked,
    ButtonTypePassed
} LevelSelectButtonType;
//关卡button 类型
@interface LevelSelectButton : CCSprite<CCTargetedTouchDelegate> 
{
    id _target;
    SEL _action;
    float oldPositionY;
}

@property (nonatomic,assign)int buttonType;
@property (nonatomic,retain)NSString* text;

- (id) initWithButtonType:(int)type text:(NSString *)text target:(id)_t selector:(SEL)_s;
@end
