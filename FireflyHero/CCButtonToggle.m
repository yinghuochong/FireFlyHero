//
//  CCButtonToggle.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-8.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "CCButtonToggle.h"

@implementation CCButtonToggle
@synthesize lableText;
@synthesize isOn=_isOn;

- (id) initFromNormalImage:(NSString *)_nImage selectedImage:(NSString *)_sImage text1:(NSString *)_text1 text2:(NSString *)_text2 target:(id)_t selector:(SEL)_s{
    
    self = [super initFromNormalImage:_nImage selectedImage:_sImage target:_t selector:_s];
    if (self) {
        text1 = _text1;
        text2 = _text2;
        lableText = [[CCLabelBMFont alloc] initWithString:_text1 fntFile:@"roundawrite-outline.fnt"];
        lableText.position = ccp(self.contentSize.width/2.0f,self.contentSize.height/2.0f);
        lableText.anchorPoint = ccp(0.75f, 0.5f);
        lableText.scale = 0.7f;
        lableText.tag = 1;
        [self addChild:lableText];
        [lableText release];
        _isOn = YES;
    }
    return self;
}

- (void)setIsOn:(Boolean)newIsOn
{
    _isOn = !newIsOn;
    [self switchText];
}

- (void)switchText
{
    _isOn = !_isOn;
    CGPoint point = lableText.anchorPoint;
    [lableText removeFromParentAndCleanup:YES];
    lableText = [[CCLabelBMFont alloc] initWithString:_isOn?text1:text2 fntFile:@"roundawrite-outline.fnt"];
    lableText.position = ccp(self.contentSize.width/2.0f,self.contentSize.height/2.0f);
    lableText.anchorPoint = point;
    lableText.scale = 0.7f;
    [self addChild:lableText];
    [lableText release];
}

- (void)dealloc {
    [super dealloc];
}

@end
