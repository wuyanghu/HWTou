//
//  MoneyEarningViewModel.h
//  HWTou
//
//  Created by Reyna on 2018/3/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "MoneyEarningModel.h"

@interface MoneyEarningViewModel : BaseViewModel

@property (nonatomic, copy) NSString *todayTips; //当日收益金额（元）
@property (nonatomic, copy) NSString *allTips; //总收益金额（元）

@property (nonatomic, strong) NSMutableArray<MoneyEarningModel *> *dataArr;

@end
