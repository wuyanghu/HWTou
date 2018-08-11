//
//  MoneyAccountModel.h
//  HWTou
//
//  Created by Reyna on 2018/2/7.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface MoneyAccountModel : BaseModel

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *freezen;
@property (nonatomic, copy) NSString *qAward;
@property (nonatomic, copy) NSString *iAward;

@end
