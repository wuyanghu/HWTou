//
//  BaseListResult.h
//  HWTou
//
//  Created by PP on 16/8/18.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "BaseResponse.h"

@protocol BaseListDelegate <NSObject>

@optional
/**
 *  数组中需要转换的模型类
 *
 *  @return 数组中存放模型的Class
 */
+ (Class)objectClassInList;

@end

@interface BaseListModel : NSObject

@property (nonatomic, assign) NSInteger total_pages;
@property (nonatomic, copy  ) NSArray   *list;

@end

@interface BaseListResult : BaseResponse <BaseListDelegate>

@property (nonatomic, strong) BaseListModel *data;

@end
