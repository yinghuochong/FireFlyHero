//
//  CCButton.h
//  VideoPuzzle
//
//  Created by Yang QianFeng on 08/08/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCButton : CCSprite <CCTargetedTouchDelegate> {
    CCTexture2D *normalTexture;
    CCTexture2D *selectTexture;
    
    id _target;
    SEL _action;
}
@property (nonatomic,assign)SEL action;
@property (nonatomic,assign)id target;
- (id) initFromNormalImage:(NSString *)_nImage selectedImage:(NSString *)_sImage target:(id)_t selector:(SEL)_s;

@end