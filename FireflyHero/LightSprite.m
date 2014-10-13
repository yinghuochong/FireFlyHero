//
//  LightSprite.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-13.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "LightSprite.h"
#import "CCAnimation+Helper.h"


@implementation LightSprite

@synthesize buttonType = _buttonType;
@synthesize onlightSprite = _onlightSprite;
@synthesize enable = _enable;

@synthesize crackSprite=_crackSprite;
@synthesize onCrackSprite=_onCrackSprite;

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode light:(Light *)light target:(id)_t selector:(SEL)_s
{
    self = [super initWithSpriteFrameName:@"LightOff1.png"];
    if (self) {
        _target = _t;
        _action = _s;
        _batchNode = batchNode;
        _interval = light.interval;
        _enable = YES;
        
        self.opacity = 255;
        self.position = ccp(light.x, light.y);
        self.buttonType = light.lightType;
        self.anchorPoint = ccp(0.5, 0.5);
        
        _onlightSprite= [[CCSprite alloc] initWithSpriteFrameName:@"LightOn1.png" ];
        _onlightSprite.anchorPoint = self.anchorPoint;
        _onlightSprite.position =self.position;
        _onlightSprite.opacity = 0;
        [batchNode addChild:self.onlightSprite];
        [_onlightSprite release];
        
        _crackSprite = nil;
        _onCrackSprite = nil;
        //坏灯泡裂纹 随机选择一种类型， 然后随机旋转一个角度
        if (_buttonType == 2) {
            _crackSprite = [[CCSprite alloc] initWithSpriteFrameName:@"LightCrackOff2.png"];
            _crackSprite.anchorPoint = ccp(1.0f, 0.0f);
            _crackSprite .rotation = arc4random()%360;
            _crackSprite .position = self.position;
            _crackSprite.opacity = self.opacity;
            [batchNode addChild:self.crackSprite z:888];
            [_crackSprite release];
            
            _onCrackSprite = [[CCSprite alloc] initWithSpriteFrameName:@"LightCrackOn2.png"];
            _onCrackSprite.anchorPoint = _crackSprite.anchorPoint;
            _onCrackSprite.rotation = _crackSprite.rotation;
            _onCrackSprite.position = _crackSprite.position;
            _onCrackSprite.opacity = _onlightSprite.opacity;
            [batchNode addChild:self.onCrackSprite z:888];
            [_onCrackSprite release];
        }
        //小灯泡 不断变大，当变到最大的时候才能用
        if (_buttonType == 4) {
            [self animationScale];
        }
        //[self.onlightSprite stopAllActions];
        CCAnimation *animation = [CCAnimation animationWithFrame:@"LightOn" frameCount:4 delay:0.2f firstNum:1];
        CCAnimate *action = [[CCAnimate alloc] initWithAnimation:animation restoreOriginalFrame:YES];
        CCRepeatForever *action2 = [[CCRepeatForever alloc] initWithAction:action];
        [self.onlightSprite runAction:action2];
        [action release];
        [action2 release];
    }
    return self;
}
#pragma mark --处理小灯泡变化
//灯泡从小变大动画
- (void)animationScale
{
    self.scale = 0.4f;
    self.enable = FALSE;
    CCScaleTo *scalto = [[CCScaleTo alloc] initWithDuration:0.3f scale:1.0f];
    CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration:_interval position:self.position];
    CCCallFunc *callfunc = [[CCCallFunc alloc] initWithTarget:self selector:@selector(becomeBig)];
    [self runAction:[CCSequence actions:moveto,scalto,callfunc, nil]];
    [scalto release];
    [moveto release];
    [callfunc release];
}
//变大之后 保持 interval 秒 等待用户点击 
- (void)becomeBig
{
    self.enable = YES;
    CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration:_interval position:self.position];
    CCCallFunc *callfunc = [[CCCallFunc alloc] initWithTarget:self selector:@selector(delayFinished)];
    [self runAction:[CCSequence actions:moveto,callfunc, nil]];
    [moveto release];
    [callfunc release];
}
//若用户点击了 ，则继续保持，否则变小
- (void)delayFinished
{
    if (self.opacity == 0) {
        CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration:_interval position:self.position];
        CCCallFunc *callfunc = [[CCCallFunc alloc] initWithTarget:self selector:@selector(delayFinished)];
        [self runAction:[CCSequence actions:moveto,callfunc, nil]];
        [moveto release];
        [callfunc release];
    }else{
        self.enable = FALSE;
        self.scale = 0.4f;
        [self animationScale];
    }
}

//点亮
- (void)lightOn
{
    self.onlightSprite.opacity = 255;
    self.opacity = 0;
    if (self.crackSprite != nil) {
        self.onCrackSprite.opacity = 255;
        self.crackSprite.opacity = 0;
    }
}
//熄灭
- (void)lightOff
{
    self.onlightSprite.opacity = 0;
    self.opacity = 255;
    if (self.onCrackSprite!=nil) {
        self.onCrackSprite.opacity = 0;
        self.crackSprite.opacity = 255;
    }
}

//坏灯泡爆炸动画
- (void)animationBlast
{
    [self lightOff];
    self.opacity = 100;
    self.crackSprite.opacity = 0;
    float distance = 50;
    float duration = 0.3;
    //禁用该button
    self.enable = NO;
    
    CCSprite *centerPiece = [[CCSprite alloc] initWithSpriteFrameName:@"BrokenLightPart3.png"];
    centerPiece.position = self.position;
    [_batchNode addChild:centerPiece z:888];
    [centerPiece release];
    
    int angle = arc4random()%360;
    CGPoint destPoint = ccp(centerPiece.position.x+distance*sin(angle*M_PI/180.0f), centerPiece.position.y+distance*cos(angle*M_PI/180.0f));
    CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration:duration position:destPoint];
    CCFadeTo *fadeto = [[CCFadeTo alloc] initWithDuration:duration opacity:0];
    CCSpawn *spawn = [CCSpawn actions:moveto,fadeto, nil];
    CCCallFuncN *callfunc = [[CCCallFuncN alloc] initWithTarget:self selector:@selector(BlastFinished:)];
    [centerPiece runAction:[CCSequence actions:spawn,callfunc,nil]];
    [moveto release];
    [fadeto release];
    [callfunc release];
    
    
    for(int i= 0,j=0 ;i<4;i++,j++)
    {
        CCSprite *bigPiece = [[CCSprite alloc] initWithSpriteFrameName:@"BrokenLightPart1.png"];
        bigPiece.position = self.position;
        bigPiece.anchorPoint = ccp(0.5, 0.0);
        bigPiece.rotation  = j*50;
        [_batchNode addChild:bigPiece z:888];
        [bigPiece release];
        
        destPoint = ccp(bigPiece.position.x+distance*sin(bigPiece.rotation*M_PI/180), bigPiece.position.y+distance*cos(bigPiece.rotation*M_PI/180));
        moveto = [[CCMoveTo alloc] initWithDuration:duration position:destPoint];
        fadeto = [[CCFadeTo alloc] initWithDuration:duration opacity:0];
        spawn = [CCSpawn actions:moveto,fadeto, nil];
        callfunc = [[CCCallFuncN alloc] initWithTarget:self selector:@selector(BlastFinished:)];
        [bigPiece runAction:[CCSequence actions:spawn,callfunc,nil]];
        [moveto release];
        [fadeto release];
        [callfunc release];
        if (j>5) return;    
        CCSprite *smallPiece = [[CCSprite alloc] initWithSpriteFrameName:@"BrokenLightPart2.png"];
        smallPiece.position = self.position;
        smallPiece.anchorPoint = ccp(0.5, 0.0);
        smallPiece.rotation = (++j)*50;
        [_batchNode addChild:smallPiece z:888];
        [smallPiece release];
        
        destPoint = ccp(smallPiece.position.x+distance*sin(smallPiece.rotation*M_PI/180.0f), smallPiece.position.y+distance*cos(smallPiece.rotation*M_PI/180.0f));
        moveto = [[CCMoveTo alloc] initWithDuration:duration position:destPoint];
        fadeto = [[CCFadeTo alloc] initWithDuration:duration opacity:0];
        spawn = [CCSpawn actions:moveto,fadeto, nil];
        callfunc = [[CCCallFuncN alloc] initWithTarget:self selector:@selector(BlastFinished:)];
        [smallPiece runAction:[CCSequence actions:spawn,callfunc,nil]];
        [moveto release];
        [fadeto release];
        [callfunc release];
        
    }
}
//爆炸动画结束
- (void)BlastFinished:(CCSprite *)sprite 
{
    [sprite removeFromParentAndCleanup:YES];
}

-(CGRect) rect
{
	return CGRectMake( position_.x - contentSize_.width*anchorPoint_.x,
					  position_.y - contentSize_.height*anchorPoint_.y,
					  contentSize_.width, contentSize_.height);	
}

- (BOOL) isInSideSprite:(UITouch *)touch {
    CGPoint point = [touch locationInView:[touch view]];
	point = [[CCDirector sharedDirector] convertToGL: point];
    point = [self convertToNodeSpace:point];
    CGRect r = [self rect];
    r.origin = CGPointZero;
    if( CGRectContainsPoint( r, point ) ) {
        return YES;
    }
    return NO;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self isInSideSprite:touch]) {
        return YES;
    }
    return NO;    
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (![self isInSideSprite:touch]) {
    }
}
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if([self isInSideSprite:touch]) {
        if (_enable && [_target respondsToSelector:_action ]) {
            [_target performSelector:_action withObject:self];
        }
    }
}

- (void) onEnter {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:kCCMenuTouchPriority swallowsTouches:YES];
    [super onEnter];
}
- (void) onExit {
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}
- (void) dealloc {
    [super dealloc];
}

@end
