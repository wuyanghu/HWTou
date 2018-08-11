//
//  ActivityDetailViewController.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ComWebViewController.h"

@class ActivityListDM;
@class ActivityNewsDM;

typedef NS_ENUM(NSInteger, ActivityDetailType)
{
    ActivityDetailList,     // 活动详情
    ActivityDetailNews,     // 新闻详情
};

@interface ActivityDetailViewController : ComWebViewController

@property (nonatomic, assign) ActivityDetailType type;
@property (nonatomic, strong) ActivityListDM *dmActivity;
@property (nonatomic, strong) ActivityNewsDM *dmNews;

@end
