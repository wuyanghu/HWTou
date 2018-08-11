//
//  SubWYAuctionPayWayViewController.h
//  HWTou
//
//  Created by robinson on 2018/4/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@interface SubWYAuctionPayWayViewController : BaseViewController
@property (nonatomic,copy) NSString * payPrice;
@property (nonatomic,copy) NSString * proveOrderId;

@property (nonatomic,assign) BOOL isSeller;//已拍中
@end
