//
//  GetFayeArtModel.h
//  HWTou
//
//  Created by robinson on 2018/4/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetFayeArtModel : BaseModel
@property (nonatomic,assign) NSInteger artId;//工艺品ID
@property (nonatomic,copy) NSString * title;//标题
@property (nonatomic,assign) NSInteger status;//0：隐藏，1：显示
@property (nonatomic,assign) NSInteger rank;//排序值
@property (nonatomic,copy) NSString * linkUrl;//链接地址
@property (nonatomic,copy) NSString * imgUrl;//底图地址
@end
