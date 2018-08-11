//
//  GetGoodsClassesModel.h
//  HWTou
//
//  Created by robinson on 2018/4/13.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetGoodsClassesModel : BaseModel
@property (nonatomic,assign) NSInteger classId;//分类ID
@property (nonatomic,copy) NSString * className;//分类名
@property (nonatomic,assign) NSInteger status;//状态：0：隐藏，1：显示
@property (nonatomic,assign) NSInteger rank;//排序值
@property (nonatomic,assign) NSInteger goodsNum;//商品量
@property (nonatomic,assign) NSInteger totalCount;//总条数
@end
