//
//  CCAnimation+Helper.m
//  oh
//
//  Created by  on 12-9-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCAnimation+Helper.h"


@implementation CCAnimation (Helper)
//直接索引图片名称
+(CCAnimation*) animationWithFile:(NSString*)name frameCount:( int )frameCount delay:( float )delay
{
    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
    NSString* file;
    for ( int i = 0; i < frameCount; i++)
    {
        file =nil;
        file = [NSString stringWithFormat:@ "%@%i.png" , name, i];
        CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:file];
        CGSize texSize = texture.contentSize;
        CGRect texRect = CGRectMake(0, 0, texSize.width, texSize.height);
        CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:texRect]; 
        
        [frames addObject:frame];
    }
    return  [CCAnimation animationWithFrames:frames delay:delay];
}
//利用帧缓存中的帧名称
+(CCAnimation*) animationWithFrame:(NSString*)frame frameCount:( int )frameCount delay:( float )delay firstNum:(int)num//:(NSString*)name
{
    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
    NSString* file; 
    
    for ( int i = num; i < num+frameCount; i++)
    {
        file =nil;
       
        file = [NSString stringWithFormat:@ "%@%d.png" , frame, i];
        
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
        [frames addObject:frame];
    }
    return  [CCAnimation animationWithFrames:frames delay:delay];
}
+(CCAnimation*) animationWithFrameFromStartFrameIndex:(NSString*)frame startFrameCountIndex:( int )startFrameIndex frameCount:( int )frameCount delay:( float )delay
{
    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
    NSString* file;
    file =nil;
    for ( int i = startFrameIndex; i < frameCount+startFrameIndex; i++)
    { 
        if ([frame isEqualToString:@"-1"]) {
            file = [NSString stringWithFormat:@ "%d%@.png" , i,frame];
        }else{
            file = [NSString stringWithFormat:@  "%@%d.png"  , frame, i];}
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
        [frames addObject:frame];
    }
    return  [CCAnimation animationWithFrames:frames delay:delay];
}
@end