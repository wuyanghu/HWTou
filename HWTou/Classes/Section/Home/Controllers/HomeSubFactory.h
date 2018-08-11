//
//  HomeSubFactory.h
//  HWTou
//
//  Created by Reyna on 2017/11/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, HomeSubType) {
    HomeSubTypeTraffic       =   0,  //路况
    HomeSubTypeHot           =   1,  //热门
    HomeSubTypeCategory      =   2,  //分类
    HomeSubTypeTopic         =   3,  //话题
    HomeSubTypeRadio         =   4,  //广播
    HomeSubTypeUnknown       =   5,  //未知
};

@interface HomeSubFactory : NSObject

/**
 *  生成子控制器
 *  @param identifier 自控制器的唯一文字标识
 */
+ (BaseViewController *)subFindControllerWithIdentifier:(NSString *)identifier;

@end
