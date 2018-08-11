//
//  LaunchAdManager.h
//  HWTou
//
//  Created by 彭鹏 on 2017/6/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LaunchAdShowCompleted)(void);

@interface LaunchAdManager : NSObject

+ (LaunchAdManager *)share;

/**
 显示广告
 @param completed 显示完成回调
 */
- (void)showLaunchAdCompleted:(LaunchAdShowCompleted)completed;

@end
