//
//  AppDelegate.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-4.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import "AppDelegate.h"
#import "cocos2d.h"
#import "StartLayer.h"
#import "SimpleAudioEngine.h"
#import "Global.h"
#import "LevelParser.h"
#import "LevelSelectButton.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if(![CCDirector setDirectorType:CCDirectorTypeDisplayLink]){
        [CCDirector setDirectorType:CCDirectorTypeDefault];
    }
    CCDirector *director = [CCDirector sharedDirector];
    [director setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
    EAGLView *glView = [[EAGLView alloc] initWithFrame:self.window.bounds];
    
    [director setOpenGLView:glView];
    [self.window addSubview:glView];
    [glView release];
    
    [director setAnimationInterval:1/60.0f];
    [director enableRetinaDisplay:YES];
    [director setDisplayFPS:YES];
    [director runWithScene:[StartLayer scene]];
    
    //*************************************
    //  加载关卡
    //  判断是否是首次启动程序, 若是，则初始化只有第一关是未锁定的 
    //**************************************
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    LevelParser *parser = [LevelParser sharedLevelParser];
    NSString *flag = [ud objectForKey:[NSString stringWithFormat:@"%d",parser.levles.count]];
    if (!flag) {
        for (int i=0; i<parser.levles.count; i++) {
            [ud setObject:[NSString stringWithFormat:@"%d",i==0?ButtonTypeUnlocked:ButtonTypeLocked] forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
        [ud setObject:@"0" forKey:@"skipLevelNum"];
    }
    g_skipLevelNum = [[ud objectForKey:@"skipLevelNum"] intValue];
    //**************************************
    // 加载声音 并读取音乐状态
    //**************************************
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"FireflyHeroTheme.mp3"];
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Click.mp3"];
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:4.0];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Chirp.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"LevelCompleted.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Star1.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Star2.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Star3.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"LightBreaking.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"FlowerPop.mp3"];
    
    //  读取音乐状态
    NSString *musicStatu = [ud objectForKey:@"musicStatu"];
    if (!musicStatu) {
        [ud setValue:@"1" forKey:@"musicStatu"];
        [ud setValue:@"1" forKey:@"soundStatu"];
    }
    g_isMusicOn = [[ud objectForKey:@"musicStatu"] intValue];
    g_isSoundOn = [[ud objectForKey:@"soundStatu"] intValue];
    if (g_isMusicOn) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"FireflyHeroTheme.mp3" loop:YES];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
