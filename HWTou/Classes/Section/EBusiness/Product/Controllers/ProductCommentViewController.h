//
//  ProductCommentViewController.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@class OrderProductDM;

@interface ProductCommentViewController : BaseViewController

@property (nonatomic, assign) NSInteger mpid;
@property (nonatomic, copy) NSArray<OrderProductDM *> *listData;

@end
