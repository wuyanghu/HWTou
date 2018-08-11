//
//  AddGoodsOrderModel.h
//  HWTou
//
//  Created by robinson on 2018/4/16.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@class AddGoodsOrderResultModel;

@interface AddGoodsOrderModel : BaseModel
@property (nonatomic,copy) NSString * orderId;//订单编号
@property (nonatomic,assign) NSInteger userId;//用户ID
@property (nonatomic,strong) NSMutableArray<AddGoodsOrderResultModel *> * sellerIdArr;//卖家ID集合

@end

@interface AddGoodsOrderResultModel:BaseModel
@property (nonatomic,assign) NSInteger sellerId;//卖家ID
@end
