//
//  MMShareView.h
//
//  Created by pengpeng on 16/5/13.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "SocialShareDM.h"
#import "MMPopupView.h"

typedef void (^ShareOperateBlock)(SocialShareType type);

@interface MMShareView : MMPopupView

@property (nonatomic, copy) ShareOperateBlock shareOperate;

@end
