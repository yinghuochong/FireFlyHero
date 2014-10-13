//
//  LevelSelectButton.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-6.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "LevelSelectButton.h"
#import "SimpleAudioEngine.h"
#import "Global.h"



@implementation LevelSelectButton

@synthesize buttonType = _buttonType;
@synthesize text = _text;


- (id) initWithButtonType:(int)type text:(NSString *)text target:(id)_t selector:(SEL)_s
{
    NSString *imageName;
    switch (type) {
        case ButtonTypeLocked:
        {
            imageName = @"LevelBoxLocked.png";
            break;
        }
        case ButtonTypeUnlocked:
        {
            imageName = @"LevelBoxUnlocked.png";
            break;
        }
        case ButtonTypePassed:
        {
            imageName = @"LevelBoxPassed.png";
            break;
        }
        case ButtonTypePassedLeaf:
        {
            imageName = @"LevelBoxPassedLeaf.png";
            break;
        }
        default:
        {
            imageName = @"LevelBoxLocked.png";
            break;
        }
    }
    
    self = [super initWithSpriteFrameName:imageName];
    if (self) {
        self.anchorPoint = ccp(0.5, 0.5);
        self.text = text;
        CCLabelBMFont *lableText = [[CCLabelBMFont alloc] initWithString:text fntFile:@"roundawrite-outline.fnt"];
        lableText.position = ccp(self.contentSize.width/2.0f,self.contentSize.height/2.0f);
        lableText.anchorPoint = ccp(0.75f, 0.5f);
        lableText.scale = 0.7f;
        lableText.opacity = type==ButtonTypeLocked?100:255;
        [self addChild:lableText];
        [lableText release];
#ifdef IS_TEST
        _target =_t; 
        _action = _s;
        g_skipLevelNum = -100;
#else
        _target = type==ButtonTypeLocked?nil:_t;
        _action = type==ButtonTypeLocked?nil:_s;
#endif
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
    oldPositionY = self.parent.position.y;
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
    if([self isInSideSprite:touch] && oldPositionY == self.parent.position.y) {
        if (g_isSoundOn)
            [[SimpleAudioEngine sharedEngine] playEffect:@"click.mp3"];
        if ([_target respondsToSelector:_action ]) {
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
    //NSLog(@"%s %s ", __FILE__, __func__);
    [_text release];
    [super dealloc];
}


@end
