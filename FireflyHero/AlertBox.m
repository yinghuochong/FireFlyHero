//
//  AlertBox.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-8.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "AlertBox.h"

@implementation AlertBox

@synthesize background;
@synthesize backButton;
@synthesize menuButtons;

- (id)initWithBackground : (NSString *)bg size:(CGSize)s backButton:(CCButton *)backbutton menuButtons:(NSArray *)array
{
    self = [super initWithColor:ccc4(0, 0, 0, 180)];
    if (self) {
        self.background = bg;
        self.backButton = backButton;
        self.menuButtons = array;
        //背景
        CCMenuItem *bgMenu = [[CCMenuItem alloc] initWithTarget:self selector:nil];
        bgMenu.contentSize = self.contentSize;
        bgMenu.anchorPoint = ccp(0.0f, 0.0f);
        bgMenu.position = ccp(-self.contentSize.width/2.0f, -self.contentSize.height/2.0f);
        
        CCMenu *menu = [CCMenu menuWithItems:bgMenu,nil];
        [bgMenu release];
        [self addChild:menu];
        
        
        CCSprite *bgSprite = [[CCSprite alloc] initWithFile:bg];
        bgSprite.anchorPoint = CGPointMake(0.5f, 0.5f);
        bgSprite.position = ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f);
        
        [self addChild:bgSprite];
        [bgSprite release];
        //返回按钮
        if (backbutton) {
            backbutton.anchorPoint = CGPointMake(0.5f, 0.5f);
            int pp = 9;
            backbutton.position = ccp(1.0/pp*bgSprite.contentSize.width, bgSprite.contentSize.height-1.0/pp*bgSprite.contentSize.height);
            backbutton.target = self;
            backbutton.action = @selector(backButtonClick);
            [bgSprite addChild:backbutton];
        }
        CCButton *button1 = (CCButton *)[array objectAtIndex:0];
        int buttonCount = array.count;
        
        float adjust = 40.0f/320*[[CCDirector sharedDirector] winSize].height;
        float gap = (bgSprite.contentSize.height-adjust-buttonCount*button1.contentSize.height)/(buttonCount+1);
        for (int i=0;i<buttonCount;i++) {
            CCButton *button = (CCButton *)[array objectAtIndex:i];
             button.anchorPoint = ccp(0.5f, 0.5f);
            button.position = ccp(self.contentSize.width/2.0f,bgSprite.position.y+(bgSprite.contentSize.height-adjust)/2.0-gap*(i+1)-button.contentSize.height/2.0f*(2*i+1));
        
            [self addChild:button];
        }
    }
    return self;
}

//返回
- (void)backButtonClick
{
    [self removeFromParentAndCleanup:YES];
}

- (void)dealloc {
    [backButton release];
    [background release];
    [menuButtons release];
    [super dealloc];
}

@end
