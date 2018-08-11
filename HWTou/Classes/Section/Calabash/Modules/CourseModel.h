//
//  CourseModel.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EnlistModel.h"
#import "TeacherModel.h"
#import "CoursesAddressModel.h"

@interface CourseModel : NSObject

@property (nonatomic, assign) NSInteger id;             // 课程 ID
@property (nonatomic, strong) NSString *title;          // 课程标题
@property (nonatomic, strong) NSString *remark;         // 简介
@property (nonatomic, strong) NSString *create_time;    // 课程时间
@property (nonatomic, assign) NSInteger status;         // 状态   备用
@property (nonatomic, assign) NSInteger t_id;           // 教师 ID
@property (nonatomic, strong) NSString *img_url;        // 展示图片
@property (nonatomic, assign) NSInteger sort;           // 排序   备用
@property (nonatomic, strong) NSString *update_time;    // 更新时间
@property (nonatomic, assign) NSInteger is_top;         // 置顶标志 1：默认 2：置顶   备用
@property (nonatomic, assign) NSInteger enlist_type;    // 报名标志 1：未报名 2：已经报名
@property (nonatomic, strong) TeacherModel *teacher;    // 教师信息列表
@property (nonatomic, strong) NSArray<CoursesAddressModel *> *addresses;    // 地址列表
@property (nonatomic, strong) EnlistModel *enlist;      // 报名信息

@end
