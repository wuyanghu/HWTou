//
//  GetSellerPerformListModel.h
//  HWTou
//
//  Created by robinson on 2018/4/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetSellerPerformListModel : BaseModel
@property (nonatomic,assign) NSInteger performId;//专场ID
@property (nonatomic,copy) NSString * title;//专场标题
@property (nonatomic,copy) NSString * bmgUrl;//专场封面图
@property (nonatomic,assign) NSInteger rank;// 专场排序值
@property (nonatomic,assign) NSInteger status;//专场状态：0：隐藏，1：显示
@end
