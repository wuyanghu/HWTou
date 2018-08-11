//
//  EnlistModel.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnlistModel : NSObject

@property (nonatomic, assign) NSInteger id;             // 报名 ID
@property (nonatomic, assign) NSInteger c_id;           // 课程 ID
@property (nonatomic, assign) NSInteger uid;            // 用户 ID
@property (nonatomic, strong) NSString *create_time;    // 报名时间
@property (nonatomic, assign) NSInteger status;         // 状态   备用
@property (nonatomic, strong) NSString *stu_id;         // 学号
@property (nonatomic, assign) NSInteger address_id;     // 报名课程地址 ID
@property (nonatomic, strong) NSString *full_name;      // 报名课程地址全称


@end
