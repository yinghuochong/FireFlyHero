//
//  GameLayer.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-5.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//
#import "CCAnimation+Helper.h"
#import "SimpleAudioEngine.h"

#import "GameLayer.h"
#import "LevelSelectLayer.h"
#import "CCTextButton.h"
#import "AlertBox.h"
#import "LevelCompletedLayer.h"
#import "StartLayer.h"
#import "LevelSelectButton.h"

#import "LightSprite.h"
#import "StarSprite.h"
#import "SpiderSprite.h"
#import "FlowerSprite.h"
#import "PumpSprite.h"

#import "Global.h"


#define FIREFLY_VELOCITY  5.0f
#define SHOW_TIPS 1

@implementation GameLayer
@synthesize currentLevel=_currentLevel;

+ (id)scene : (NSString *)level 
{
    CCScene *scene = [[CCScene alloc] init];
    GameLayer *layer = [[GameLayer alloc] initWithLevel:level];
    [scene addChild:layer];
    [layer release];
    return [scene autorelease];
}

- (id)initWithLevel:(NSString *)level 
{
    self = [super init];
    if (self) {
        parser = [LevelParser sharedLevelParser];
        self.currentLevel = level;
        [self loadGame];
    }
    return self;
}

//碰撞检测
- (void)checkCollide
{     
    //分数栏的位置
    CGRect rect = scoreSprite.textureRect;
    if (rect.size.width<142.0f/maxScore*currentScore) {
        [scoreSprite setTextureRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width+5, rect.size.height)];
    }  
    rect = scoreSprite.textureRect;
    //萤火虫的位置和boundingbox
    firefly.collideSprite.position = firefly.position; 
    firefly.collideSprite.rotation = firefly.rotation;
    firefly.fireflyShadow.position = ccp(firefly.position.x, firefly.position.y-15);
    
    CGRect rect2 = firefly.collideSprite.boundingBox;
    
    //检测星星
    for (int i=stars.count-1;i>=0;i--) {
        StarSprite *star = [stars objectAtIndex:i];
        CGRect rect1 = star.boundingBox;
        if (!CGRectIsNull(CGRectIntersection(rect1, rect2))) {
            //将星星移除
            if (g_isSoundOn)
                [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"Star%d.mp3",arc4random()%3+1]];
            currentScore+=scoreOfPerStar;
            [star removefromGamelayerWithScorePostion:ccp(scoreSprite.position.x+rect.size.width,scoreSprite.position.y)];  
            [stars removeObject:star];
        }
    }
    
    //检测星星是否已经被收集完成  成功啦
    if (stars.count == 0) {
        if (g_isSoundOn)
            [[SimpleAudioEngine sharedEngine] playEffect:@"LevelCompleted.mp3"];
        
        // level score  //main  replay  next
        float duration = 0.5;
        
        CCTextButton *mainButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Small.png" selectedImage:@"Button-Yellow-Small-Off.png" text:@"main" target:self selector:@selector(mainButtonClicked:)];
        CCTextButton *replayButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Small.png" selectedImage:@"Button-Yellow-Small-Off.png" text:@"replay" target:self selector:@selector(replayButtonClicked:)];
        CCTextButton *nextButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Small.png" selectedImage:@"Button-Yellow-Small-Off.png" text:@"next" target:self selector:@selector(nextButtonClicked:)];
        NSArray *array = [NSArray arrayWithObjects:mainButton,replayButton,nextButton, nil];
        [mainButton release];
        [replayButton release];
        [nextButton release];
        
        CCColorLayer *colorLayer = [[CCColorLayer alloc] initWithColor:ccc4(0, 0, 0, 0)];
        CCFadeTo *fadeto = [[CCFadeTo alloc] initWithDuration:duration opacity:180];
        [self addChild:colorLayer z:99999998];
        [colorLayer runAction:fadeto];
        [fadeto release];
        [colorLayer release];
        LevelCompletedLayer *completeLayer = [[LevelCompletedLayer alloc] initWithLevel:_currentLevel currentScore:currentScore maxScore:maxScore goldScore:goldScore menuButtons:array];
        completeLayer.anchorPoint = ccp(0.5, 0.5);
        completeLayer.position = ccp(self.contentSize.width/2.0f, self.contentSize.height*3);
        [self addChild:completeLayer z:99999999];
        [completeLayer release];
        [self unschedule:@selector(checkCollide)];
        CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration:duration position:ccp(self.contentSize.width/2.0f, self.contentSize.height/2.0f)];
        [completeLayer runAction:moveto];
        [moveto release];
        return;
    }
    
    //检测耙子
    for (int i=spikes.count-1; i>=0; i--) {
        CCSprite *spikeSprite = [spikes objectAtIndex:i];
        CGRect rect1 = spikeSprite.boundingBox;
        if (!CGRectIsNull(CGRectIntersection(rect1, rect2))) {
            [self fail];
            return;
        }
    }
    //检测蜘蛛网
    for (int i= 0; i<spiders.count;i++) {
        SpiderSprite *spider = [spiders objectAtIndex:i];
        CGRect rect3 = spider.boundingBox;  //蜘蛛
        for (int j=0; j<spider.webs.count; j++) {
            CCSprite *webSprite = [spider.webs objectAtIndex:j];
            CGRect rect1 = webSprite.boundingBox ; //网
            
            if (!CGRectIsNull(CGRectIntersection(rect1, rect2)) || !CGRectIsNull(CGRectIntersection(rect3, rect2))) {
                [self fail];
                return;
            }
        }
    }
    //检测花球
    for (int i= 0; i<flowers.count;i++) {
        FlowerSprite *flower = [flowers objectAtIndex:i];
        for (int j=0; j<flower.flowerBalls.count; j++) {
            CCSprite *flowerBall = [flower.flowerBalls objectAtIndex:j];
            CGRect rect1 = flowerBall.boundingBox ; //花球
            if (!CGRectIsNull(CGRectIntersection(rect1, rect2))) {
                [self fail];
                return;
            }
        }
    }
    //检测风扇
    for (int i=0; i<fans.count; i++) {
        CCSprite *fan = [fans objectAtIndex:i];
        if( !isInfan && firefly.position.x > fan.position.x-fan.contentSize.width/2.0f && firefly.position.x <fan.position.x+fan.contentSize.width/2.0f){
            isInfan = true;
            //[firefly stopActionByTag:11111];
            
            ccBezierConfig config = {ccp(fan.position.x+fan.contentSize.width/2.0f, firefly.position.y),ccp(firefly.position.x+30, 200),ccp(fan.position.x+fan.contentSize.width/2.0f-30, 200)};
            CCBezierTo *bezierto = [[CCBezierTo alloc] initWithDuration:1.0f bezier:config];
            
            CCCallFunc *callfunc = [[CCCallFunc alloc] initWithTarget:self selector:@selector(moveInFunFinished)];
            
            [firefly runAction:[CCSequence actions:bezierto,callfunc,nil]];
            [bezierto release];
            [callfunc release];
            
            NSLog(@"come in ");
            
        }
    }
}

- (void)moveInFunFinished
{
    isInfan = false;
    
//    CCMoveTo *moveto = [[CCMoveTo alloc] initWithDuration:1.5 position:ccp(200, firefly.position.y)];
//    CCEaseOut *easeOut = [[CCEaseOut alloc] initWithAction:moveto rate:1];
//    
//    [firefly runAction:easeOut];
//    [moveto release];
//    [easeOut release];
    
    NSLog(@"moveInfinished finished");
}
 
- (void)fireflyHoloAnimationFinished
{
    [self loadGame];
}

- (void)fail
{
    [firefly stopAllanimation];
    [firefly animationFeeler];
    [firefly animationHalo];
    //禁用所有的按钮
    for (int k=0; k<lights.count; k++) {
        LightSprite *light = [lights objectAtIndex:k];
        light.enable = NO;
    }
    [self unschedule:@selector(checkCollide)];
}

- (void)mainButtonClicked:(CCButton *)button
{
    CCTransitionSlideInL *translation = [[CCTransitionSlideInL alloc] initWithDuration:0.3f scene:[StartLayer scene]];
    [[CCDirector sharedDirector] replaceScene:translation];
    [translation release];
}
- (void)replayButtonClicked:(CCButton *)button
{
    NSLog(@"replay clicked ,currentLevel: %@",_currentLevel);
    [self loadGame];
}

- (void)nextButtonClicked:(CCButton *)button
{
    [_currentLevel release];
    _currentLevel = [[NSString stringWithFormat:@"%d",[_currentLevel intValue]+1] retain];
    NSLog(@"next clicked ,currentLevel: %@",_currentLevel);
    [self loadGame];
}

- (void)loadGame
{
    [stars release];
    [lights release];
    [spikes release];
    [spiders release];
    [fans release];
    [flowers release];
    
    [self unscheduleAllSelectors];
    [self stopAllActions];
    [self removeAllChildrenWithCleanup:YES];
    //刷新动画
    CCColorLayer *layer = [[CCColorLayer alloc] initWithColor:ccc4(0, 0, 0, 220)];
    layer.contentSize = self.contentSize;
    [self addChild:layer z:99999999];
    [layer release];
    CCFadeTo *fadeto = [[CCFadeTo alloc] initWithDuration:0.5 opacity:0];
    [layer runAction:fadeto];
    [fadeto release];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    
    batchNode = [CCSpriteBatchNode batchNodeWithFile:@"GameElements.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GameElements.plist"];
    [self addChild:batchNode z:100];
    
    Level *thisLevel = [parser.levles objectForKey:_currentLevel];
    //分数相关
    scoreOfPerStar = (float)thisLevel.maxScore/thisLevel.stars.count;
    goldScore = thisLevel.goldScore;
    lightPenalty = thisLevel.lightPenalty;
    currentScore = 0;
    maxScore = thisLevel.maxScore;
    //背景
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *bgSprite = [[CCSprite alloc] initWithFile:[NSString stringWithFormat:@"Bg-Player-%@.png",thisLevel.background]];
    bgSprite.anchorPoint = ccp(0.5f, 0.5f);
    bgSprite.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
    [self addChild:bgSprite];
    [bgSprite release];
    
    //当前关卡
    CCLabelBMFont *lableText = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"level : %@",_currentLevel] fntFile:@"roundawrite-outline.fnt"];
    lableText.position = ccp(lableText.contentSize.width/2.0f-25.0f,lableText.contentSize.height/2.0f);
    lableText.anchorPoint = ccp(0.5f, 0.5f);
    lableText.scale = 0.5f;
    [self addChild:lableText];
    [lableText release];
    
    //刷新菜单
    CCMenuItem *refresh = [[CCMenuItem alloc] initWithTarget:self selector:@selector(refreshGame)];
    refresh.contentSize = CGSizeMake(35.0f, 35.0f);
    refresh.anchorPoint = ccp(0.0f, 1.0f);
    refresh.position = ccp(-winSize.width/2.0f, winSize.height/2.0f);
    //暂停菜单
    CCMenuItem *pause = [[CCMenuItem alloc] initWithTarget:self selector:@selector(pauseGame)];
    pause.contentSize = CGSizeMake(35.0f, 35.0f);
    pause.anchorPoint = ccp(1.0f, 1.0f);
    pause.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
    
    CCMenu *menu = [CCMenu menuWithItems:refresh,pause, nil];
    [refresh release];
    [pause release];
    [self addChild:menu];
    
    //分数条
    scoreSprite = [[CCSprite alloc] initWithSpriteFrameName:@"ScoreBar.png"];
    scoreSprite.anchorPoint = ccp(0.0f, 0.5f);
    scoreSprite.position = ccp(winSize.width/2.0f-71, 306.0f);
    [scoreSprite setTextureRect:CGRectMake(0, 493, 0, 12)];   // 0,493,142,12
    [batchNode addChild:scoreSprite];
    [scoreSprite release];
    
    //金叶子
    CCSprite *goldLeaf = [[CCSprite alloc] initWithSpriteFrameName:@"LeafDisabled.png"];
    goldLeaf.anchorPoint = ccp(0.5f, 0.5f);
    goldLeaf.position = ccp(winSize.width/2.0f+60, 308.0f);
    goldLeaf.opacity = 200;
    [batchNode addChild:goldLeaf];
    [goldLeaf release];
    //添加主角 萤火虫
    
    firefly = [[FireflySprite alloc] initWithBatchNode:batchNode postion:ccp(thisLevel.heroX, thisLevel.heroY)];
    [batchNode addChild:firefly z:999];
    [firefly animationFeeler];
    [firefly release];
    firefly.delegate = self;
    
    
    //添加灯泡 1：正常灯泡   2：坏的灯泡
    lights = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<thisLevel.lights.count; i++) {
        Light *oneLight = [thisLevel.lights objectAtIndex:i];
        LightSprite *lightButton = [[LightSprite alloc] initWithBatchNode:batchNode light:oneLight target:self selector:@selector(lightButtonClicked:)];
        [lights addObject:lightButton];
        [batchNode addChild:lightButton];
        [lightButton release];
    }
    
    //添加星星
    stars = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<thisLevel.stars.count; i++) {
        Star *oneStar = [thisLevel.stars objectAtIndex:i];
        StarSprite *starSprite = [[StarSprite alloc] initWithBatchNode:batchNode postion:ccp(oneStar.x, oneStar.y)];
        [batchNode addChild:starSprite];
        [stars addObject:starSprite];
        [starSprite release];
        //星星闪烁效果
        [starSprite animationBlink];
    }
    //添加蜘蛛
    spiders = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<thisLevel.spiders.count; i++) {
        Spider *oneSpider = [thisLevel.spiders objectAtIndex:i];
        SpiderSprite *spiderSprite = [[SpiderSprite alloc] initWithBatchNode:batchNode points:oneSpider.points];
        spiderSprite.position = ccp(oneSpider.x, oneSpider.y);
        [batchNode addChild:spiderSprite z:888];
        [spiders addObject:spiderSprite];
        [spiderSprite release];
        [spiderSprite animationMakeWeb];
    }
    //添加耙子
    spikes = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<thisLevel.spikes.count; i++) {
        Spike *oneSpike = [thisLevel.spikes objectAtIndex:i];
        CCSprite *spikeSprite = [[CCSprite alloc] initWithSpriteFrameName:[NSString stringWithFormat:@"Spike%d.png",oneSpike.length]];
        spikeSprite.rotation = oneSpike.angle;
        spikeSprite.position = ccp(oneSpike.x, oneSpike.y);
        [batchNode addChild:spikeSprite];
        [spikes addObject:spikeSprite];
        [spikeSprite release];  
    }
    
    CCSpriteBatchNode* batchNodePump = [CCSpriteBatchNode batchNodeWithFile:@"pump.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"pump.plist"];
    [self addChild:batchNodePump];
    //添加 打气筒
    fans = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<thisLevel.fans.count; i++) {
        Fan *oneFan = [thisLevel.fans objectAtIndex:i];
        PumpSprite *fanSprite = [[PumpSprite alloc] initWithBatchNode:batchNode target:self selector:@selector(PumpClicked:)];
        //fanSprite.scale = 0.8f;
        fanSprite.tag = 1;
        fanSprite.anchorPoint = ccp(0.5f, 0.5f);
        fanSprite.rotation = oneFan.angle;
        fanSprite.position = ccp(oneFan.x, oneFan.y);
        [batchNodePump addChild:fanSprite];
        [fans addObject:fanSprite];
        [fanSprite release]; 
    }
    
    //添加花
    flowers = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<thisLevel.flowers.count; i++) {
        Flower *oneFlower = [thisLevel.flowers objectAtIndex:i];
        FlowerSprite *flowerSprite = [[FlowerSprite alloc] initWithBatchNode:batchNode];
        flowerSprite.position = ccp(oneFlower.x, oneFlower.y);
        [batchNode addChild:flowerSprite];
        [flowers addObject:flowerSprite];
        [flowerSprite release]; 
        [flowerSprite animationWithInterval:oneFlower.interval delay:oneFlower.delay];
    }
    
#if SHOW_TIPS
    //添加提示
    for (int i=0; i<thisLevel.tips.count; i++) {
        Tip *oneTip = [thisLevel.tips objectAtIndex:i];
        CCSprite *tipSprite = [[CCSprite alloc] initWithFile:[NSString stringWithFormat:@"%@.png",oneTip.name]];
        tipSprite.position = ccp(oneTip.x, oneTip.y);
        [self addChild:tipSprite];
        [tipSprite release];
    }
#endif
    //加载结束 ，启动定时器碰撞检测
    [self schedule:@selector(checkCollide)];
}

- (void)PumpClicked : (PumpSprite *)pump
{
    if (pump.tag == 1) {
        [pump runAnimation];
    }
}

- (void)lightButtonClicked:(LightSprite *)lightButton
{
    [firefly stopAllanimation];
    //萤火虫运动动作
    [firefly animationWingsAndFeeler];
    //点亮选中的灯泡
    for (LightSprite *button in lights)
    {
        if (button.onlightSprite.opacity == 255) {
            [button lightOff];
            if(currentScore>=lightPenalty)currentScore-=lightPenalty;
            if (button.buttonType == 2) {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                if ([[ud objectForKey:@"soundStatu"] intValue])
                    [[SimpleAudioEngine sharedEngine] playEffect:@"LightBreaking.mp3"];
                [button animationBlast];
            }
        }  
    }
    [lightButton lightOn];    
    //计算萤火虫运动方向和终点
    float deltaX = firefly.position.x - lightButton.position.x;
    float deltaY = firefly.position.y - lightButton.position.y;
    
    float angle = atanf(deltaX/deltaY)*180/M_PI; 
    
    float ratio = ((lightButton.contentSize.width)/2.0f/(sqrtf(deltaY*deltaY+deltaX*deltaX)));
    float realX = lightButton.position.x + (deltaX * ratio);
    float realY = lightButton.position.y + (deltaY * ratio);
    angle = deltaY>0?angle-180:angle;
    if (deltaX<=0 && deltaY == 0) {
        angle = 90;
    }else if (deltaX>=0 && deltaY == 0) {
        angle = -90;
    }    
    float length = sqrtf(deltaY*deltaY+deltaX*deltaX)-(lightButton.contentSize.width)/2.0f;
    [firefly animationWithMoveTo:ccp(realX, realY) :FIREFLY_VELOCITY*length/480.0f :angle];
    destPosition = ccp(realX, realY);
}

- (void)refreshGame
{
    NSLog(@"refresh clicked ,currentLevel: %@",_currentLevel);
    [self loadGame]; 
    //NSDate UIColor
}

- (void)pauseGame
{
    [[CCDirector sharedDirector] pause];
    if(g_isMusicOn)[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    CCTextButton *continueButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Large.png" selectedImage:@"Button-Yellow-Large-Off.png" text:@"continu" target:self selector:@selector(continueButtonClick:)];
    
    CCTextButton *skipSelectButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Large.png" selectedImage:@"Button-Yellow-Large-Off.png" text:@"skip level" target:self selector:@selector(skipButtonClick:)];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    LevelSelectButtonType type = [[ud objectForKey:[NSString stringWithFormat:@"%d",[_currentLevel intValue]+1]] intValue];
    skipSelectButton.enable = g_skipLevelNum>=5 && type == ButtonTypeLocked;
    
    CCTextButton *levelSelectButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Large.png" selectedImage:@"Button-Yellow-Large-Off.png" text:@"level select" target:self selector:@selector(backButtonClick:)];
    
    CCTextButton *mainMenuButton = [[CCTextButton alloc] initFromNormalImage:@"Button-Yellow-Large.png" selectedImage:@"Button-Yellow-Large-Off.png" text:@"main menu" target:self selector:@selector(mainMenuClicked:)];
    
    AlertBox *alertBox = [[AlertBox alloc] initWithBackground:@"Bg-Options.png" size:CGSizeMake(130.0f, 180.0f) backButton:nil menuButtons:[NSArray arrayWithObjects:continueButton,skipSelectButton,levelSelectButton,mainMenuButton, nil]];
    [continueButton release];
    [levelSelectButton release];
    [skipSelectButton release];
    [mainMenuButton release];
    [self addChild:alertBox z:999];
    [alertBox release];
}

- (void)mainMenuClicked : (CCTextButton *)button
{
    [[CCDirector sharedDirector] resume];
    if(g_isMusicOn)[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    CCTransitionSlideInL *translation = [[CCTransitionSlideInL alloc] initWithDuration:0.3f scene:[StartLayer scene]];
    [[CCDirector sharedDirector] replaceScene:translation];
    [translation release];
}

- (void)continueButtonClick:(CCTextButton *)button
{
    //移除对话框
    [[button parent] removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector] resume];
    if(g_isMusicOn) [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

- (void)skipButtonClick:(CCTextButton *)button
{  
    [[CCDirector sharedDirector] resume];
    if(g_isMusicOn)[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    if ([_currentLevel intValue] == parser.levles.count) {
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    LevelSelectButtonType type = [[ud objectForKey:[NSString stringWithFormat:@"%d",[_currentLevel intValue]+1]] intValue];
    if (type != ButtonTypeLocked){
        [_currentLevel release];
        _currentLevel = [[NSString stringWithFormat:@"%d",[_currentLevel intValue]+1] retain];
        NSLog(@"skipButtonClick ,currentLevel: %@",_currentLevel);
        [self loadGame];
    }else {
        if (g_skipLevelNum<5) {
            g_skipLevelNum++;
            [ud setObject:[NSString stringWithFormat:@"%d",g_skipLevelNum] forKey:@"skipLevelNum"];
            [ud setObject:[NSString stringWithFormat:@"%d",ButtonTypeUnlocked] forKey:[NSString stringWithFormat:@"%d",[_currentLevel intValue]+1]];
            [_currentLevel release];
            _currentLevel = [[NSString stringWithFormat:@"%d",[_currentLevel intValue]+1] retain];
            NSLog(@"skipButtonClick ,currentLevel: %@",_currentLevel);
            [self loadGame];
        }else{
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
            NSString *text=@"you can't skip more than \n\nfive level!";
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
        }}
}

- (void)okButtonClick: (CCButton *)button
{
    [button.parent.parent removeFromParentAndCleanup:YES];
}

- (void)backButtonClick:(CCTextButton *)button
{
    [[CCDirector sharedDirector] resume];
    if(g_isMusicOn)[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    [[button parent] removeFromParentAndCleanup:YES];
    CCTransitionSlideInL *translation = [[CCTransitionSlideInL alloc] initWithDuration:0.5f scene:[LevelSelectLayer scene]];
    [[CCDirector sharedDirector] replaceScene:translation];
    [translation release];
}

-(void)dealloc
{
    [stars release];
    [lights release];
    [spikes release];
    [spiders release];
    [fans release];
    [flowers release];
    [_currentLevel release];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    
    [super dealloc];
}
@end
