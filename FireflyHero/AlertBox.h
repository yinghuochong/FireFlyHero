//
//  AlertBox.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-8.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCButton.h"

@interface AlertBox : CCColorLayer

@property (nonatomic,retain) NSString *background;
@property (nonatomic,retain) CCButton *backButton;
@property (nonatomic,retain) NSArray *menuButtons;

- (id)initWithBackground : (NSString *)bg size:(CGSize)s backButton:(CCButton *)backbutton menuButtons:(NSArray *)array;
@end
