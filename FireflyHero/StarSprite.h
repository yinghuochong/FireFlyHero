//
//  StarSprite.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-13.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "cocos2d.h"

@interface StarSprite : CCSprite
{
    CCSpriteBatchNode *_batchNode;
}
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode postion:(CGPoint)p;
- (void)animationBlink;
- (void)removefromGamelayerWithScorePostion:(CGPoint)scorePostion;
@end
