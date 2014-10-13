//
//  SpiderSprite.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-14.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "cocos2d.h"

@interface SpiderSprite : CCSprite
{
    CCSpriteBatchNode *_batchNode;
    CCSprite *_currentWeb;      //当前织的网
    CGPoint *_points;
    int _pointsCount;
    NSMutableArray *_webs;
}
@property (nonatomic,assign)NSMutableArray *webs;
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode points:(NSArray*)points;
- (void)animationMakeWeb;
@end
