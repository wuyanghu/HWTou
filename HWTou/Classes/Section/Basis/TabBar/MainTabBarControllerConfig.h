//
//  MainTabBarControllerConfig.h
//  HWTou
//
//  Created by Reyna on 2017/12/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLTabBarController.h"

@interface MainTabBarControllerConfig : NSObject

@property (nonatomic, readonly, strong) CYLTabBarController *tabBarController;

+ (instancetype)sharedInstance;

@end
