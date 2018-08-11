//
//  ActivityListDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityListDM : NSObject

@property (nonatomic, assign) NSInteger act_id;         // 活动编号
@property (nonatomic, assign) NSInteger type;           // 1:进行中 2:已结束 3: 未开始
@property (nonatomic, assign) NSInteger read_num;       // 阅读量
@property (nonatomic, assign) NSInteger alike_num;      // 点赞量
@property (nonatomic, copy) NSString *title;            // 标题
@property (nonatomic, copy) NSString *remark;           // 标题描述
@property (nonatomic, copy) NSString *link;             // 点击链接 Url
@property (nonatomic, copy) NSString *img_url;          // 展示图片 Url

@property (nonatomic, copy) NSString *start_time;       // 活动开始时间
@property (nonatomic, copy) NSString *end_time;         // 活动结束时间
@property (nonatomic, strong) NSDate *startDate;         // 活动结束时间
@property (nonatomic, strong) NSDate *endDate;         // 活动结束时间

@property (nonatomic, assign) BOOL sign_flag;           // 是否报名
@property (nonatomic, assign) BOOL collected_flag;      // 是否收藏

@end
