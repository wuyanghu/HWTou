//
//  CoursesAddressModel.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoursesAddressModel : NSObject

@property (nonatomic, assign) NSInteger id;             // 地址 ID
@property (nonatomic, assign) NSInteger p_id;           // 省份 ID
@property (nonatomic, assign) NSInteger city_id;        // 城市 ID
@property (nonatomic, assign) NSInteger d_id;           // 区域 ID
@property (nonatomic, assign) NSInteger c_id;           // 课程 ID
@property (nonatomic, strong) NSString *address;        // 详细地址
@property (nonatomic, strong) NSString *full_name;      // 地址全称
@property (nonatomic, strong) NSString *create_time;    // 新增时间
@property (nonatomic, strong) NSString *update_time;    // 更新时间
@property (nonatomic, assign) NSInteger status;         // 状态   备用
@property (nonatomic, assign) NSInteger is_top;         // 置顶标志 1：默认 2：置顶   备用

@end
