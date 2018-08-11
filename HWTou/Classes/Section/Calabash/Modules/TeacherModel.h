//
//  TeacherModel.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherModel : NSObject

@property (nonatomic, assign) NSInteger id;             // 教师 ID
@property (nonatomic, strong) NSString *name;           // 教师名称
@property (nonatomic, strong) NSString *remark;         // 简介
@property (nonatomic, strong) NSString *img_url;        // 展示图片
@property (nonatomic, assign) NSInteger sort;           // 排序   备用
@property (nonatomic, assign) NSInteger is_top;         // 置顶标志 1：默认 2：置顶   备用
@property (nonatomic, strong) NSString *create_time;    // 新增时间
@property (nonatomic, strong) NSString *update_time;    // 更新时间
@property (nonatomic, assign) NSInteger status;         // 状态   备用

@end
