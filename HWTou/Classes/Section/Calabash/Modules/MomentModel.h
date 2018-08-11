//
//  MomentModel.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MediaModel.h"
#import "UserDataModel.h"

@interface MomentModel : NSObject

@property (nonatomic, assign) NSInteger id;                     // 内容 ID
@property (nonatomic, strong) NSString *remark;                 // 分享内容
@property (nonatomic, strong) NSString *create_time;            // 发布时间
@property (nonatomic, assign) NSInteger uid;                    // 用户 ID
@property (nonatomic, strong) UserDataModel *userData;          // 用户数据
@property (nonatomic, strong) NSArray<MediaModel *> *imgs;      // 媒体列表

@end
