//
//  CCTextButton.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-8.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "CCTextButton.h"

@implementation CCTextButton
@synthesize lableText=_lableText;
@synthesize enable=_enable;

- (void)setEnable:(BOOL)newEnable
{
    _enable = newEnable;
    if (_enable) {
        _lableText.opacity = 100;
    }else{
        _lableText.opacity  = 255;
    }
}

- (id) initFromNormalImage:(NSString *)_nImage selectedImage:(NSString *)_sImage text:(NSString *)text target:(id)_t selector:(SEL)_s
{
    self = [super initFromNormalImage:_nImage selectedImage:_sImage target:_t selector:_s];
    if (self) {
        _lableText = [[CCLabelBMFont alloc] initWithString:text fntFile:@"roundawrite-outline.fnt"];
        _lableText.position = ccp(self.contentSize.width/2.0f,self.contentSize.height/2.0f);
        _lableText.anchorPoint = ccp(0.5f, 0.5f);
        _lableText.scale = 0.7f;
        [self addChild:_lableText];
    }
    return self;
}
-(void)dealloc
{
    [_lableText release];
    [super dealloc];
}
@end
