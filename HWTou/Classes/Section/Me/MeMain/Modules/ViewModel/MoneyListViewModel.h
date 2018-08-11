//
//  MoneyListViewModel.h
//  HWTou
//
//  Created by Reyna on 2018/2/2.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "MoneyListModel.h"

@interface MoneyListViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray<MoneyListModel *> *dataArr;

@end
