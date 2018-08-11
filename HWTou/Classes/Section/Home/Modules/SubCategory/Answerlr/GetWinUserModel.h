//
//  GetWinUserModel.h
//  HWTou
//
//  Created by robinson on 2018/2/5.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetWinUserModel : BaseModel
@property (nonatomic,assign) NSInteger total;//获奖用户总数
@property (nonatomic,strong) NSMutableArray * userResultModelArr;
@end

@interface GetWinUserResultModel : BaseModel
@property (nonatomic,copy) NSString * headUrl;//用户头像
@property (nonatomic,copy) NSString * nickname;//用户昵称
@property (nonatomic,copy) NSString * money;//获奖金额
@end


