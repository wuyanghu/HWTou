//
//  InvestView.h
//  HWTou
//
//  Created by 彭鹏 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerAdDM;
@class InvestProductDM;
@class InvestActivityDM;

@interface InvestView : UIView

// 投资列表
@property (nonatomic, copy) NSArray<InvestProductDM *> *listData;

// 横幅广告
@property (nonatomic, copy) NSArray<BannerAdDM *> *banners;

// 投资活动
@property (nonatomic, copy) NSArray<InvestActivityDM *> *ativity;

@property (nonatomic, readonly) UITableView *tableView;

/**
 滚动到产品位置
 */
- (void)scrollToProductPosition;

@end
