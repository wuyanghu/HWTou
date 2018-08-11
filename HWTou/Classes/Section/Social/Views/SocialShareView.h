//
//  MMShareView.h
//
//  Created by pengpeng on 16/5/13.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "SocialShareDM.h"
#import <UIKit/UIKit.h>

typedef void (^ShareOperateBlock)(SocialShareType type);

@interface SocialShareView : UIView

@property (nonatomic, copy) ShareOperateBlock shareOperate;

@end
