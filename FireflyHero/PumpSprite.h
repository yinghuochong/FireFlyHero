//
//  PumpSprite.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-21.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "cocos2d.h"

@interface PumpSprite : CCSprite<CCTargetedTouchDelegate> 
{
    id _target;
    SEL _action;
    CCSpriteBatchNode *_batchNode;
}

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode target:(id)_t selector:(SEL)_s;

- (void)runAnimation;
@end

