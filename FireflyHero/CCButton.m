//
//  CCButton.m
//  VideoPuzzle
//
//  Created by Yang QianFeng on 08/08/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "CCButton.h"
#import "SimpleAudioEngine.h"
#import "Global.h"

@implementation CCButton
@synthesize action=_action;
@synthesize target=_target;

- (id) initFromNormalImage:(NSString *)_nImage selectedImage:(NSString *)_sImage target:(id)_t selector:(SEL)_s {
    normalTexture = [[[CCTextureCache sharedTextureCache] addImage:_nImage] retain];
    selectTexture = [[[CCTextureCache sharedTextureCache] addImage:_sImage] retain];
    
    self = [super initWithTexture:normalTexture];
    if (self) {
        CGSize size = normalTexture.contentSize;
        self.contentSize = size;
        _target = _t;
        _action = _s;
    }
    return self;
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
        self.texture = selectTexture;
        return YES;
    }
    return NO;    
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (![self isInSideSprite:touch]) {
        self.texture = normalTexture;
    }
}
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    self.texture = normalTexture;
    if([self isInSideSprite:touch]) {
        if (g_isSoundOn)
            [[SimpleAudioEngine sharedEngine] playEffect:@"click.mp3"];
        if ([_target respondsToSelector:_action]) {
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
    [normalTexture release];
    [selectTexture release];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [super dealloc];
}

@end
