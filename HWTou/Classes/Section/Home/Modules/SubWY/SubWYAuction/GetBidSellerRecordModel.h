//
//  GetBidSellerRecordModel.h
//  HWTou
//
//  Created by robinson on 2018/4/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetBidSellerRecordModel : BaseModel
@property (nonatomic,assign) NSInteger bidId;//竞价记录ID
@property (nonatomic,assign) NSInteger userId;//用户ID
@property (nonatomic,copy) NSString * userName;//用户名
@property (nonatomic,copy) NSString * userPhone;//用户手机号
@property (nonatomic,copy) NSString * bidTime;
@property (nonatomic,assign) NSInteger acvId;// 活动ID
@property (nonatomic,assign) NSInteger sellerGoodsId ;// 拍卖品ID
@property (nonatomic,assign) NSInteger sellerId;// 卖家ID
@property (nonatomic,assign) NSInteger performId;//专场ID
@property (nonatomic,copy) NSString * bidMoney;//竞价金额
@property (nonatomic,assign) NSInteger isDone;//是否成交；0：否，1：是
@property (nonatomic,assign) NSInteger totalCount;//总条数
@end
