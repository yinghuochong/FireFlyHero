//
//  LevelParser.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-19.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "Level.h"

@interface LevelParser:NSObject
{
    NSMutableDictionary *_levles;
}
@property (nonatomic,retain) NSMutableDictionary *levles;
+ (LevelParser *)sharedLevelParser;
@end
