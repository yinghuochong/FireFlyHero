//
//  StartLayer.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-4.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCButtonToggle.h"
#import "OAuthManager.h"

@interface StartLayer : CCLayer<OAuthManagerDelegate>
{
    CCSpriteBatchNode *batchNode;
    OAuthManager* tencentOAuthManager;
    CCLayer *grayLayer;
}
+ (id) scene;
- (void)createSprites;
@end
