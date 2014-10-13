//
//  LevelParser.m
//  FireflyHero
//
//  Created by lihua liu on 12-9-19.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//


#import "LevelParser.h"

@implementation LevelParser
@synthesize levles=_levles;

static LevelParser* parser;

bool isFromSelf;
+(id)alloc
{
    if (isFromSelf) {
        return [super alloc];
    }
    return nil;
}
//单例
+ (LevelParser *)sharedLevelParser
{
    @synchronized(self){
        if (parser == nil) {
            isFromSelf = YES;
            parser= [[LevelParser alloc] init];
            isFromSelf = NO;
        }
    }
    return parser;
}

-(id)init
{
    self = [super init];
    if (self) {
        _levles = [[NSMutableDictionary alloc] init];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Levels3.xml" ofType:nil];
        NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
        [xmlData release];
        if (error) {
            NSLog(@"level load failed! error info : %@",error);
        }
        GDataXMLElement *rootElement = [doc rootElement];
        NSArray *allLevels = [rootElement elementsForName:@"level"];
        
        for (GDataXMLElement *level in allLevels) {
            Level *oneLevel = [[Level alloc] init];
            //等级基本信息
            oneLevel.level = [[level attributeForName:@"number"] stringValue];
            oneLevel.heroX = [[[level attributeForName:@"heroX"] stringValue]intValue];
            oneLevel.heroY = [[[level attributeForName:@"heroY"] stringValue]intValue];
            oneLevel.lightPenalty = [[[level attributeForName:@"lightPenalty"] stringValue]intValue];
            oneLevel.maxScore = [[[level attributeForName:@"maxScore"] stringValue]intValue];
            oneLevel.goldScore = [[[level attributeForName:@"goldScore"] stringValue]intValue];
            //if ([oneLevel.level intValue]<=20) {
            //    oneLevel.background = [[level attributeForName:@"background"] stringValue];
           // }else{
                oneLevel.background = [NSString stringWithFormat:@"%d",arc4random()%3+1];
           // }
            //星星
            NSMutableArray *stars = [[NSMutableArray alloc] init];
            NSArray *allStars = [level elementsForName:@"star"];
            for (GDataXMLElement *star in allStars) {
                Star *oneStar = [[Star alloc] init];
                oneStar.x = [[[star attributeForName:@"x"] stringValue]intValue];
                oneStar.y = [[[star attributeForName:@"y"] stringValue]intValue];
                [stars addObject:oneStar];
                [oneStar release];
            }
            oneLevel.stars = stars;
            [stars release];
            //灯泡
            NSMutableArray *lights = [[NSMutableArray alloc] init];
            NSArray *allLights = [level elementsForName:@"light"];
            for (GDataXMLElement *light in allLights) {
                Light *oneLight = [[Light alloc] init];
                oneLight.x = [[[light attributeForName:@"x"] stringValue]intValue];
                oneLight.y = [[[light attributeForName:@"y"] stringValue]intValue];
                oneLight.lightType = [[[light attributeForName:@"lightType"] stringValue]intValue];
                if (oneLight.lightType == 4) {
                    oneLight.interval = [[[light attributeForName:@"interval"] stringValue]intValue];
                }
                [lights addObject:oneLight];
                [oneLight release];
            }
            oneLevel.lights = lights;
            [lights release];           
            //蜘蛛
            NSMutableArray *spiders = [[NSMutableArray alloc] init];
            NSArray *allSpiders = [level elementsForName:@"spider"];
            for (GDataXMLElement *spider in allSpiders) {
                Spider *oneSpider = [[Spider alloc] init];
                oneSpider.speed= [[[spider attributeForName:@"speed"] stringValue]intValue];
                NSArray *intArray = [[[spider attributeForName:@"points"] stringValue] componentsSeparatedByString:@", "];
                oneSpider.x = [[intArray objectAtIndex:0] intValue];
                oneSpider.y = [[intArray objectAtIndex:1] intValue];;
                oneSpider.points = intArray;
                [spiders addObject:oneSpider];
                [oneSpider release];
            }
            oneLevel.spiders = spiders;
            [spiders release];
            //提示
            NSMutableArray *tips = [[NSMutableArray alloc] init];
            NSArray *allTips = [level elementsForName:@"tip"];
            for (GDataXMLElement *tip in allTips) {
                Tip *oneTip = [[Tip alloc] init];
                oneTip.x = [[[tip attributeForName:@"x"] stringValue]intValue];
                oneTip.y = [[[tip attributeForName:@"y"] stringValue]intValue];
                oneTip.name = [[tip attributeForName:@"name"] stringValue];
                [tips addObject:oneTip];
                [oneTip release];
            }
            oneLevel.tips = tips;
            [tips release];
            //耙子
            NSMutableArray *spikes = [[NSMutableArray alloc] init];
            NSArray *allSpikes = [level elementsForName:@"spike"];
            for (GDataXMLElement *spike in allSpikes) {
                Spike *oneSpike = [[Spike alloc] init];
                oneSpike.x = [[[spike attributeForName:@"x"] stringValue]intValue];
                oneSpike.y = [[[spike attributeForName:@"y"] stringValue]intValue];
                oneSpike.length = [[[spike attributeForName:@"length"] stringValue]intValue];
                oneSpike.angle = [[[spike attributeForName:@"angle"] stringValue]intValue];
                [spikes addObject:oneSpike];
                [oneSpike release];
            }
            oneLevel.spikes = spikes;
            [spikes release];
            //风扇
            NSMutableArray *fans = [[NSMutableArray alloc] init];
            NSArray *allFans = [level elementsForName:@"fan"];
            for (GDataXMLElement *fan in allFans) {
                Fan *oneFan = [[Fan alloc] init];
                oneFan.x = [[[fan attributeForName:@"x"] stringValue]intValue];
                oneFan.y = [[[fan attributeForName:@"y"] stringValue]intValue];
                oneFan.angle = [[[fan attributeForName:@"angle"] stringValue]intValue];
                [fans addObject:oneFan];
                [oneFan release];
            }
            oneLevel.fans = fans;
            [fans release];
            //花
            NSMutableArray *flowers = [[NSMutableArray alloc] init];
            NSArray *allFlowers = [level elementsForName:@"flower"];
            for (GDataXMLElement *flower in allFlowers) {
                Flower *oneFlower = [[Flower alloc] init];
                oneFlower.x = [[[flower attributeForName:@"x"] stringValue]intValue];
                oneFlower.y = [[[flower attributeForName:@"y"] stringValue]intValue];
                oneFlower.interval = [[[flower attributeForName:@"interval"] stringValue]intValue];
                oneFlower.delay = [[[flower attributeForName:@"delay"] stringValue]intValue];
                [flowers addObject:oneFlower];
                [oneFlower release];
            }
            oneLevel.flowers = flowers;
            [flowers release];
            
            [_levles setObject:oneLevel forKey:oneLevel.level];
            [oneLevel release];
        }
        [doc release];
    }
    return self;
}

-(void)dealloc
{
    [_levles release];
    [super dealloc];
}
@end
