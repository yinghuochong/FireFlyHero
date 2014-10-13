//
//  SpiderSprite.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-14.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "SpiderSprite.h"
#import "CommonMethod.h"
#import "CCAnimation+Helper.h"
#import "FireflySprite.h"
#import "CommonMethod.h"

//蜘蛛移动速度
#define SPIDER_VELOCITY  20.0f

@implementation SpiderSprite
@synthesize webs=_webs;
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode points:(NSArray*)ps
{
    self = [super initWithSpriteFrameName:@"Spider8.png"];
    if (self) {
        _batchNode = batchNode;
        _pointsCount = ps.count/2;
        self.anchorPoint = ccp(0.5f, 0.5f);
        
        _webs = [[NSMutableArray alloc] initWithCapacity:0];
        //解析节点 并且增加小柱子
        _points = malloc(sizeof(CGPoint) * ps.count);
        if (!_points) {
            NSLog(@"create spidersprite : malloc failed");
            return self;
        }
        for (int i=0; i<ps.count; i+=2) {
            _points[i/2] = ccp([[ps objectAtIndex:i] intValue] , [[ps objectAtIndex:i+1] intValue]);
            
            CCSprite *spiderPoint = [[CCSprite alloc] initWithSpriteFrameName:@"SpiderPoint1.png"];
            spiderPoint.position = _points[i/2];
            [_batchNode addChild:spiderPoint z:887];
            [spiderPoint release];
        }
    }
    return self;
}

//边走边织网
- (void)animationMakeWeb
{
    self.rotation = [CommonMethod getAngleWithPoint1:_points[0] point2:_points[1]];
    NSMutableArray *actions = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<_pointsCount-1; i++) {
        //计算方向
        float angle = [CommonMethod getAngleWithPoint1:_points[i] point2:_points[i+1]];
        float length = ccpDistance(_points[i], _points[i+1]);
        
        CCRotateTo *rotateTo = [[CCRotateTo alloc] initWithDuration:0.2f angle:angle];
        
        CCCallFunc *callfunc = [[CCCallFunc alloc] initWithTarget:self selector:@selector(rotateFinished)];
        CCSequence *webSequence = [CCSequence actions:rotateTo,callfunc, nil];
        [callfunc release];
        [rotateTo release];
        
        CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration:SPIDER_VELOCITY*length/480.0f position:_points[i+1]];
        //移动到下一个节点
        CCAnimation *animation = [CCAnimation animationWithFrame:@"Spider" frameCount:6 delay:0.1f firstNum:1];
        CCAnimate *action = [[CCAnimate alloc] initWithAnimation:animation];
        //自身动画
        CCRepeat *repeat = [[CCRepeat alloc] initWithAction:action times:SPIDER_VELOCITY*length/480.0f/0.6f+1]; 
        CCSpawn *spawn = [CCSpawn actions:moveto,repeat, nil];
        [action release]; 
        [repeat release];
        [moveto release];
        //结点
        animation = [CCAnimation animationWithFrame:@"Spider" frameCount:2 delay:0.1f firstNum:7];
        action = [[CCAnimate alloc] initWithAnimation:animation];
        repeat = [[CCRepeat alloc] initWithAction:action times:5];
        callfunc = [[CCCallFunc alloc] initWithTarget:self selector:@selector(makeWebFinished)];
        CCSequence *sequence = [CCSequence actions:webSequence, spawn,repeat,callfunc, nil];
        [callfunc release];
        [actions addObject:sequence];
        [action release];
        [repeat release];
    }
    [self runAction:[CCSequence actionsWithArray:actions]];
    [actions release];
    
    [self schedule:@selector(CreateWeb) interval:SPIDER_VELOCITY/480.0f];
}
//蜘蛛旋转完成的时候创建网
- (void)rotateFinished
{
    [self unschedule:@selector(CreateWeb)];
    CCSprite *webSprite = [[CCSprite alloc] initWithSpriteFrameName:@"SpiderWeb.png"];
    webSprite.anchorPoint = ccp(0.0f, 0.5f);
    webSprite.position = self.position ;
    webSprite.rotation = self.rotation+90;
    [webSprite setTextureRect:CGRectMake(0, 507,2, 6)];
    [_batchNode addChild:webSprite];
    [_webs addObject:webSprite];
    _currentWeb = webSprite;
    [webSprite release];
    [self schedule:@selector(CreateWeb) interval:SPIDER_VELOCITY/480.0f];
}
//所有的网都织完
- (void)makeWebFinished
{
    [self unschedule:@selector(CreateWeb)];
}

//织网  为了碰撞检测，每隔一小段就重新建一个web精灵
- (void)CreateWeb
{
    if (_currentWeb != nil) {
        float distance = ccpDistance(_currentWeb.position, self.position);
        [_currentWeb setTextureRect:CGRectMake(0, 507, distance, 6)];
        if (distance >16) {
            CCSprite *webSprite = [[CCSprite alloc] initWithSpriteFrameName:@"SpiderWeb.png"];
            webSprite.anchorPoint = ccp(0.0f, 0.5f);
            webSprite.position = self.position ;
            webSprite.rotation = self.rotation+90;
            [webSprite setTextureRect:CGRectMake(0, 507,2, 6)];
            [_batchNode addChild:webSprite];
            [_webs addObject:webSprite];
            _currentWeb = webSprite;
            [webSprite release];
        }
    }
}

- (void)dealloc {
    [_webs release];
    free(_points);
    [super dealloc];
}
@end
