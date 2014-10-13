//
//  FireflySprite.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-13.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "cocos2d.h"

@protocol FireflySpriteDelegate <NSObject>
@required
- (void)fireflyHoloAnimationFinished;

@end

@interface FireflySprite : CCSprite
{
    CCSpriteBatchNode *_batchNode;
    id<FireflySpriteDelegate> delegate;
}
@property (nonatomic,assign) id<FireflySpriteDelegate> delegate;
@property(nonatomic,readonly) CCSprite *collideSprite;
@property(nonatomic,readonly) CCSprite *fireflyShadow;

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode postion:(CGPoint)p;
- (void)animationFeeler;
- (void)animationWingsAndFeeler;
- (void)animationWithMoveTo:(CGPoint)point:(float)duration:(float) angle ;
- (void)animationHalo;

- (void)stopAllanimation;
@end
