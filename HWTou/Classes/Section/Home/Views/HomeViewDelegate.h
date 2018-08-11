//
//  HomeViewDelegate.h
//  HWTou
//
//  Created by pengpeng on 17/3/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeConfigDM.h"

@protocol HomeViewDelegate <NSObject>

/**
 首页配置模块事件

 @param position 点击位置
 */
- (void)onHomeConfigPosition:(HomePosition)position;

/**
 首页互动事件

 @param scrollView 滑动view
 */
- (void)homeScrollViewDidScroll:(UIScrollView *)scrollView;

@end
