//
//  StartLayer.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-4.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "StartLayer.h"
#import "LevelSelectLayer.h"
#import "AlertBox.h"
#import "CCTextButton.h"
#import "SimpleAudioEngine.h"
#import "Global.h"
#import "LevelParser.h"
#import "LevelSelectButton.h"


#define LATITUDE "29.658223"
#define LONGITUDE "91.141102"

@implementation StartLayer

+ (id) scene
{
    CCScene *scene = [[CCScene alloc] init];
    StartLayer *layer = [[StartLayer alloc] init];
    [scene addChild:layer];
    [layer release];
    return [scene autorelease];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self createSprites];
        tencentOAuthManager = [[OAuthManager alloc] initWithOAuthManager:TENCENT_WEIBO];
        tencentOAuthManager.delegate = self;
    }
    return self;
}

//创建首页的精灵
- (void)createSprites
{
    //背景精灵
    CCSprite *bgSprite = [[CCSprite alloc] initWithFile:@"Bg-MainMenu.png"];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    bgSprite.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
    [self addChild:bgSprite];
    [bgSprite release];
    
    CCParticleSystemQuad *particle = [[CCParticleSystemQuad alloc] initWithFile:@"starParticle.plist"];
    [self addChild:particle];
    [particle release];
    
    //-----------------------------------------------------------------------------------------------------   
    //萤火虫精灵
    CCLayer *fireflyHero = [[CCLayer alloc] init];
    fireflyHero.position = ccp(90.0f,0.0f);
    batchNode = [[CCSpriteBatchNode alloc] initWithFile:@"Hero.png" capacity:0];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Hero.plist"];
    [fireflyHero addChild:batchNode];
    [batchNode release];
    
    CCSprite *head =[[CCSprite alloc] initWithSpriteFrameName:@"Head.png"];
    head.position = ccp(0.0f, 0.0f);
    CCSprite *body = [[CCSprite alloc] initWithSpriteFrameName:@"Body.png"];
    body.position = ccp(0.0f, -90.0f);
    CCSprite *leftWing = [[CCSprite alloc] initWithSpriteFrameName:@"LeftWing.png"];
    leftWing.position = ccp(-5.0f, -20.0f);
    leftWing.anchorPoint = ccp(1.0f, 1.0f);
    CCSprite *rightWing = [[CCSprite alloc] initWithSpriteFrameName:@"RightWing.png"];
    rightWing.position = ccp(5.0f, -20.0f);
    rightWing.anchorPoint = ccp(0.0f, 1.0f);
    
    [batchNode addChild:body];
    [batchNode addChild:leftWing];
    [batchNode addChild:rightWing];
    [batchNode addChild:head];
    [head release];
    [body release];
    [leftWing release];
    [rightWing release];
    
    
    CCSprite *eyelids1 = [[CCSprite alloc] initWithSpriteFrameName:@"Eyelids3.png"];
    eyelids1.position = ccp(0.0f, -10.0f);
    [batchNode addChild:eyelids1];
    [eyelids1 release];
    
    CCBlink *blinkblank = [[CCBlink alloc] initWithDuration:0.0f blinks:1.0f];
    CCBlink *blink = [[CCBlink alloc] initWithDuration:0.2f blinks:1.0f];
    CCMoveTo *moveTo = [[CCMoveTo alloc] initWithDuration:5.0f position:ccp(0.0f,-10.0f)];
    [eyelids1 runAction:blinkblank];
    CCSequence *sequence = [CCSequence actions:moveTo,blink,moveTo,blink,blink, nil];
    CCRepeatForever *action2 = [[CCRepeatForever alloc] initWithAction:sequence];
    [blinkblank release];
    [blink release];
    [moveTo release];
    [eyelids1 runAction:action2];
    [action2 release];
    
    
    [self addChild:fireflyHero];
    [fireflyHero release];
    
    //从下面弹出
    CCMoveTo *move = [[CCMoveTo alloc] initWithDuration:0.5f position:ccp(90.0f, 120.0f)];
    [fireflyHero runAction:move];
    [move release];
    
    //两个翅膀扇动
    CCRotateTo *rotateLeft = [[CCRotateTo alloc] initWithDuration:0.1f angle:3.0f];
    CCRotateTo *rotateRight = [[CCRotateTo alloc] initWithDuration:0.1f angle:-3.0f];
    [leftWing runAction:[CCSequence actions:rotateRight,rotateLeft,rotateRight,rotateLeft, nil]];
    [rightWing runAction:[CCSequence actions:rotateLeft,rotateRight,rotateLeft,rotateRight, nil]];
    [rotateLeft release];
    [rotateRight release];
    //---------------------------------------------------------------------------------------------------------   
    //两个 button 精灵
    CCTextButton *optionButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Medium.png" selectedImage:@"Button-Yellow-Medium-Off.png" text:@"options" target:self selector:@selector(optionsMenuClick)];
    optionButton.position = ccp(300.0f, 28.0f);
    [self addChild:optionButton];
    [optionButton release];
    
    CCTextButton *playButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-XL.png" selectedImage:@"Button-Yellow-XL-Off.png" text:@"play" target:self selector:@selector(playMenuClick)];
    playButton.position = ccp(410.0f, 30.0f);
    playButton.lableText.rotation = 3.0f;
    playButton.lableText.scale = 0.8f;
    playButton.lableText.anchorPoint = ccp(0.5f, 0.35f);
    [self addChild:playButton];
    [playButton release];
}

- (void)playMenuClick
{
    CCTransitionSlideInR *translation = [[CCTransitionSlideInR alloc] initWithDuration:0.3f scene:[LevelSelectLayer scene]];
    [[CCDirector sharedDirector] replaceScene:translation];
    [translation release];
}

#pragma mark --选项相关

- (void)optionsMenuClick
{
    //打开选项对话框
    //返回按
    CCButton *backButton = [[CCButton alloc] initFromNormalImage:@"Button-Back.png" selectedImage:@"Button-Back-Pressed.png" target:nil selector:nil];
    
    CCButtonToggle *musicSetButton = [[CCButtonToggle alloc] initFromNormalImage:@"Button-Yellow-Large.png" selectedImage:@"Button-Yellow-Large-Off.png" text1:@"Music on" text2:@"Music off" target:self selector:@selector(musicSetClick:)];
    musicSetButton.lableText.anchorPoint = ccp(0.45, 0.5);
    [musicSetButton setIsOn:g_isMusicOn];
    
    CCButtonToggle *soundSetButton = [[CCButtonToggle alloc] initFromNormalImage:@"Button-Yellow-Large.png" selectedImage:@"Button-Yellow-Large-Off.png" text1:@"Sound on" text2:@"Sound off" target:self selector:@selector(soundSetClick:)];
    soundSetButton.lableText.anchorPoint = ccp(0.45, 0.5);
    [soundSetButton setIsOn:g_isSoundOn];
    
    CCTextButton *resetButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Large.png" selectedImage:@"Button-Yellow-Large-Off.png" text:@"Reset game" target:self selector:@selector(resetButtonClick:)];
    
    CCTextButton *weiboButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Large.png" selectedImage:@"Button-Yellow-Large-Off.png" text:@"share game" target:self selector:@selector(weiboButtonClick:)];
    
    
    AlertBox *alertBox = [[AlertBox alloc] initWithBackground:@"Bg-Options.png" size:CGSizeMake(343.0f, 318.0f) backButton:backButton menuButtons:[NSArray arrayWithObjects:musicSetButton,soundSetButton,resetButton,weiboButton, nil]];
    [musicSetButton release];
    [soundSetButton release];
    [backButton release];
    [resetButton release];
    [weiboButton release];
    
    [self addChild:alertBox];
    [alertBox release];
}
//重置游戏
- (void)resetButtonClick:(CCButton *)button
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCLayer *layer = [[CCLayer alloc] init];
    layer.position = ccp(0,0);
    
    CCMenuItem *bgMenu = [[CCMenuItem alloc] initWithTarget:self selector:nil];
    bgMenu.contentSize = self.contentSize;
    bgMenu.anchorPoint = ccp(0.0f, 0.0f);
    bgMenu.position = ccp(-self.contentSize.width/2.0f, -self.contentSize.height/2.0f);
    
    CCMenu *menu = [CCMenu menuWithItems:bgMenu,nil];
    [bgMenu release];
    [layer addChild:menu];
    
    CCSprite *bgsprite = [[CCSprite alloc] initWithFile:@"AlertBox.png"];
    bgsprite.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
    NSString *text=@"are you sure to reset     \n \nthis game?";
    CCLabelBMFont *labelText = [[CCLabelBMFont alloc] initWithString:text fntFile:@"roundawrite-outline.fnt"];
    labelText.position = ccp(bgsprite.position.x,bgsprite.position.y);
    // labelText
    //    labelText.anchorPoint = ccp(0.5f, 0.5f);
    labelText.scale = 0.7f;
    [bgsprite addChild:labelText];
    [labelText release];
    
    CCTextButton *yesButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Small.png" selectedImage:@"Button-Yellow-Small-Off.png" text:@"yes" target:self selector:@selector(yesButtonClick:)];
    CCTextButton *noButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Small.png" selectedImage:@"Button-Yellow-Small-Off.png" text:@"no" target:self selector:@selector(noButtonClick:)];
    
    yesButton.position = ccp(bgsprite.position.x-75-10, bgsprite.position.y-80.0f);
    noButton.position = ccp(bgsprite.position.x+75-10, bgsprite.position.y-80.0f);
    [bgsprite addChild:yesButton z:101];
    [bgsprite addChild:noButton z:101];
    [yesButton release];
    [noButton release];
    [layer addChild:bgsprite z:100];
    [bgsprite release];
    
    [self addChild:layer];
    [layer release];
}

- (void)yesButtonClick:(CCTextButton *)button
{
    LevelParser *parser = [LevelParser sharedLevelParser];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    for (int i=0; i<parser.levles.count; i++) {
        [ud setObject:[NSString stringWithFormat:@"%d",i==0?ButtonTypeUnlocked:ButtonTypeLocked] forKey:[NSString stringWithFormat:@"%d",i+1]];
    }
    [ud setObject:@"0" forKey:@"skipLevelNum"];
    g_skipLevelNum = 0;
    [button.parent.parent removeFromParentAndCleanup:YES];
}
- (void)noButtonClick:(CCTextButton *)button
{
    [button.parent.parent removeFromParentAndCleanup:YES];
}

- (void)okButtonClick: (CCButton *)button
{
    [button.parent.parent removeFromParentAndCleanup:YES];
}
//音效
- (void)soundSetClick:(CCButton *)button
{
    CCButtonToggle *toggleButton = (CCButtonToggle *)button;
    [toggleButton switchText];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:[NSString stringWithFormat:@"%d",toggleButton.isOn] forKey:@"soundStatu"];
    g_isSoundOn = toggleButton.isOn;
}
//背景音乐
- (void)musicSetClick:(CCButton *)button
{
    CCButtonToggle *toggleButton = (CCButtonToggle *)button;
    [toggleButton switchText];
    if (toggleButton.isOn) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"FireflyHeroTheme.mp3" loop:YES];
    }else{
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:[NSString stringWithFormat:@"%d",toggleButton.isOn] forKey:@"musicStatu"];
    g_isMusicOn = toggleButton.isOn;
}

#pragma mark -----微博分享

//在微博引擎中自己加的代理函数  
- (void)loginFinished:(OAuthManager *)manager
{
    if ([tencentOAuthManager isAlreadyLogin]) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        grayLayer = [[CCColorLayer alloc] initWithColor:ccc4(0, 0, 0, 180)];
        grayLayer.position = ccp(0,0);
        
        CCMenuItem *bgMenu = [[CCMenuItem alloc] initWithTarget:self selector:nil];
        bgMenu.contentSize = self.contentSize;
        bgMenu.anchorPoint = ccp(0.0f, 0.0f);
        bgMenu.position = ccp(-self.contentSize.width/2.0f, -self.contentSize.height/2.0f);
        
        CCMenu *menu = [CCMenu menuWithItems:bgMenu,nil];
        [bgMenu release];
        [grayLayer addChild:menu];
        
        CCSprite *waitsprite = [[CCSprite alloc] initWithFile:@"wait.png"];
        waitsprite.scale = 0.5;
        waitsprite.position = ccp(winSize.width/2.0f, winSize.height/2.0f);  
        [grayLayer addChild:waitsprite];
        CCRotateTo *rotateTo = [[CCRotateTo alloc] initWithDuration:100 angle:36000];
        [waitsprite runAction:rotateTo];
        [rotateTo release];
        [waitsprite release];
        
        CCLabelBMFont* lableText = [[CCLabelBMFont alloc] initWithString:@"sharing..." fntFile:@"roundawrite-outline.fnt"];
        lableText.position = ccp(self.contentSize.width/2.0f,self.contentSize.height/2.0f-40);
        lableText.anchorPoint = ccp(0.5f, 0.5f);
        lableText.scale = 0.7f;
        [grayLayer addChild:lableText];
        [lableText release];
        
        [self addChild:grayLayer z:10000];
        [grayLayer release];
        
        //分享内容
        UIImage *image = [UIImage imageNamed:@"share.png"];
        NSString * text = @"这个游戏太有意思啦，分享给大家 ，《萤火虫英雄》 --david liu";
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        NSURL *url = [NSURL URLWithString:@"https://open.t.qq.com/api/t/add_pic"];
        ASIFormDataRequest *postPicWeibo = [ASIFormDataRequest requestWithURL:url];
        [postPicWeibo setPostValue:@"json" forKey:@"format"];
        [postPicWeibo setPostValue:text forKey:@"content"];
        [postPicWeibo addData:data withFileName:@"test2xx.jpg" andContentType:@"image/png" forKey:@"pic"];
        [postPicWeibo setPostValue:[NSString stringWithUTF8String:LATITUDE] forKey:@"latitude"];
        [postPicWeibo setPostValue:[NSString stringWithUTF8String:LONGITUDE] forKey:@"longitude"];
        [postPicWeibo setPostValue:@"0" forKey:@"syncflag"];
        [postPicWeibo setPostValue:@"221.223.249.130" forKey:@"clientip"];
        [tencentOAuthManager addPrivatePostParamsForASI:postPicWeibo];
        
        [postPicWeibo setDelegate:self];
        postPicWeibo.tag = 102;
        [postPicWeibo startAsynchronous];
    }
}

- (void)weiboButtonClick:(CCButton *)button
{
    if (![tencentOAuthManager isAlreadyLogin]) {
        [tencentOAuthManager login];
        return;
    } else{
        [self loginFinished:tencentOAuthManager];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"error info : %@",[request error]);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [grayLayer removeFromParentAndCleanup:YES];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCLayer *layer = [[CCLayer alloc] init];
    layer.position = ccp(0,0);
    
    CCMenuItem *bgMenu = [[CCMenuItem alloc] initWithTarget:self selector:nil];
    bgMenu.contentSize = self.contentSize;
    bgMenu.anchorPoint = ccp(0.0f, 0.0f);
    bgMenu.position = ccp(-self.contentSize.width/2.0f, -self.contentSize.height/2.0f);
    
    CCMenu *menu = [CCMenu menuWithItems:bgMenu,nil];
    [bgMenu release];
    [layer addChild:menu];
    
    CCSprite *bgsprite = [[CCSprite alloc] initWithFile:@"AlertBox.png"];
    bgsprite.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
    NSString *text = @"share success !";
    CCLabelBMFont *labelText = [[CCLabelBMFont alloc] initWithString:text fntFile:@"roundawrite-outline.fnt"];
    labelText.position = ccp(bgsprite.position.x,bgsprite.position.y);
    labelText.scale = 0.7f;
    [bgsprite addChild:labelText];
    [labelText release];
    
    CCTextButton *okButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Small.png" selectedImage:@"Button-Yellow-Small-Off.png" text:@"ok" target:self selector:@selector(okButtonClick:)];
    okButton.position = ccp(bgsprite.position.x-10, bgsprite.position.y-80.0f);
    [bgsprite addChild:okButton z:101];
    [okButton release];
    [layer addChild:bgsprite z:100];
    [bgsprite release];
    
    [self addChild:layer z:10000];
    [layer release];
    NSLog(@"post pic: %@",[request responseString]); 
}

- (void)dealloc {
    [tencentOAuthManager release];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [super dealloc];
}
@end
