//
//  OrderCommitViewController.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@class ProductCartDM;

@interface OrderCommitViewController : BaseViewController

@property (nonatomic, copy) NSArray<ProductCartDM *> *carts;

@end
