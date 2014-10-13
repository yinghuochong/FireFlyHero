//
//  CCButtonToggle.h
//  FireflyHero
//
//  Created by lihua liu on 12-9-8.
//  Copyright (c) 2012年 yinghuochong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCButton.h"

@interface CCButtonToggle : CCButton
{
    NSString *text1;
    NSString *text2;
    Boolean _isOn;
}
@property (nonatomic,assign)CCLabelBMFont *lableText;
@property (nonatomic,assign)Boolean isOn;
- (id) initFromNormalImage:(NSString *)_nImage selectedImage:(NSString *)_sImage text1:(NSString *)_text1 text2:(NSString *)_text2 target:(id)_t selector:(SEL)_s;
- (void)switchText;
@end
