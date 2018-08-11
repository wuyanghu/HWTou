//
//  HomeSubFactory.m
//  HWTou
//
//  Created by Reyna on 2017/11/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeSubFactory.h"
#import "HomeSubTrafficController.h"         //路况
#import "HomeSubHotController.h"             //热门
#import "HomeSubCategoryController.h"        //分类
#import "HomeSubTopicController.h"           //话题
#import "HomeSubRadioController.h"           //广播

@implementation HomeSubFactory

/**
 *  生成子控制器
 *  @param identifier 自控制器的唯一文字标识
 */
+ (BaseViewController *)subFindControllerWithIdentifier:(NSString *)identifier {
    HomeSubType subType = [self typeFromTitle:identifier];
    
    BaseViewController *controller = nil;
    
    if(subType == HomeSubTypeTraffic) {
        controller = [[HomeSubTrafficController alloc] init];         //路况
    }
    else if(subType == HomeSubTypeHot) {
        controller = [[HomeSubHotController alloc] init];             //热门
    }
    else if(subType == HomeSubTypeCategory) {
        controller = [[HomeSubCategoryController alloc] init];        //分类
    }
    else if(subType == HomeSubTypeTopic) {
        controller = [[HomeSubTopicController alloc] init];           //话题
    }
    else if(subType == HomeSubTypeRadio) {
        controller = [[HomeSubRadioController alloc] init];           //广播
    }
    else {
        controller = [[BaseViewController alloc] init];               //未知
    }
    
    return controller;
}



/**
 *  根据唯一标识符范围类型
 */
+ (HomeSubType)typeFromTitle:(NSString *)title {
    if([title isEqualToString:@"聊吧"]) {
        return HomeSubTypeTraffic;
    }else if([title isEqualToString:@"热门"]) {
        return HomeSubTypeHot;
    }else if([title isEqualToString:@"聊吧"]) {
        return HomeSubTypeCategory;
    }else if([title isEqualToString:@"主播"]) {
        return HomeSubTypeTopic;
    }else if([title isEqualToString:@"电台"]) {
        return HomeSubTypeRadio;
    }else{
        return HomeSubTypeUnknown;;
    }
}

@end
