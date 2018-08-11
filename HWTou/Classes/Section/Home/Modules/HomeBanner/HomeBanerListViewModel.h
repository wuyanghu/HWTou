//
//  HomeBanerListViewModel.h
//  HWTou
//
//  Created by robinson on 2017/12/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "RotRequest.h"

@class HomeBannerListModel;

@interface HomeBanerListViewModel : BaseViewModel
@property (nonatomic,strong) BannerListParam * bannerListParam;
@property (nonatomic,strong) NSMutableArray<HomeBannerListModel *> * dataArray;
- (void)bindWithDic:(NSArray *)data;
@end
