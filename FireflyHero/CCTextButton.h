//
//  CCTextButton.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-8.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCButton.h"

@interface CCTextButton : CCButton

@property(nonatomic,retain) CCLabelBMFont *lableText;
@property(nonatomic,assign) BOOL enable;

- (id) initFromNormalImage:(NSString *)_nImage selectedImage:(NSString *)_sImage text:(NSString *)text target:(id)_t selector:(SEL)_s;

@end
