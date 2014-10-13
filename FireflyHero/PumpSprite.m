//
//  PumpSprite.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-21.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "PumpSprite.h"
#import "CCAnimation+Helper.h"

@implementation PumpSprite

- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode target:(id)_t selector:(SEL)_s
{
    self = [super initWithSpriteFrameName:@"pump1.png"];
    if (self) {
        _target = _t;
        _action = _s;
        _batchNode = batchNode;
    }
    return self;
}

- (void)runAnimation
{
    self.tag = 2;
    CCAnimation *animation = [CCAnimation animationWithFrame:@"pump" frameCount:6 delay:0.05 firstNum:1];
    CCAnimate *action = [[CCAnimate alloc] initWithAnimation:animation restoreOriginalFrame:YES];
    CCCallFunc *callfunc = [[CCCallFunc alloc] initWithTarget:self selector:@selector(animationFinished)];
    [self runAction:[CCSequence actions:action,callfunc, nil]];
    [action release];
    [callfunc release];
}

- (void)animationFinished
{
    self.tag = 1;
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
        if ( [_target respondsToSelector:_action ]) {
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
