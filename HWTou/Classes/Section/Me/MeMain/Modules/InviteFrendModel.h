//
//  InviteFrendModel.h
//  HWTou
//
//  Created by robinson on 2018/1/16.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface InviteFrendModel : BaseModel

@property (nonatomic,assign) NSInteger uid;//用户ID
@property (nonatomic,copy) NSString * nickname ;//昵称
@property (nonatomic,copy) NSString * headUrl;//头像
@property (nonatomic,copy) NSString * sign;//签名
@property (nonatomic,assign) NSInteger createTime;//邀请注册时间（客户端格式化一下）

@property (nonatomic,copy) NSString * createTimeStr;

@end
