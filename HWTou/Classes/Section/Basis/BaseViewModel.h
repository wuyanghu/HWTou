//
//  BaseViewModel.h
//  HWTou
//
//  Created by Reyna on 2017/11/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface BaseViewModel : BaseModel

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int pagesize;

@property (nonatomic, assign) BOOL isMoreData;

@property (nonatomic, assign) BOOL isRefresh;


- (void)bindWithDic:(NSDictionary *)dic isRefresh:(BOOL)isRefresh;
- (void)insertData:(BOOL)isRefresh dataArray:(NSMutableArray *)dataArray newResultArr:(NSMutableArray *)newResultArr;
@end
