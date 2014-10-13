//
//  CCAnimation+Helper.h
//  oh
//
//  Created by  on 12-9-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCAnimation (Helper)
//直接索引图片名称
+(CCAnimation*) animationWithFile:(NSString*)name frameCount:( int )frameCount delay:( float )delay;
//利用帧缓存中的帧名称
+(CCAnimation*) animationWithFrame:(NSString*)frame frameCount:( int )frameCount delay:( float )delay firstNum:(int)num;
+(CCAnimation*) animationWithFrameFromStartFrameIndex:(NSString*)frame startFrameCountIndex:( int )startFrameIndex frameCount:( int )frameCount delay:( float )delay;
@end