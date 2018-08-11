//
//  GetGoodsAddrListModel.h
//  HWTou
//
//  Created by robinson on 2018/4/12.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetGoodsAddrListModel : BaseModel
@property (nonatomic,assign) NSInteger addrId;//收件人ID
@property (nonatomic,assign) NSInteger userId;// 用户ID
@property (nonatomic,copy) NSString * addrName;//收件人姓名
@property (nonatomic,copy) NSString * addrPhone;//收件人联系电话
@property (nonatomic,copy) NSString * address ;//收件人地址
@property (nonatomic,copy) NSString * addressDetail;//收件人详细地址
@property (nonatomic,assign) NSInteger isDef;//是否是默认地址：0：否，1：是
@end
