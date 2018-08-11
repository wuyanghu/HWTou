//
//  MakeCopperView.h
//  HWTou
//
//  Created by 张维扬 on 2017/8/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "makeCopperReq.h"
#import "BannerAdDM.h"

@class InvestProductDM;
@class InvestActivityDM;

@interface MakeCopperView : UIView

// 投资列表
@property (nonatomic, copy) NSArray<InvestProductDM *> *listData;

// 横幅广告
@property (nonatomic, copy) NSArray<BannerAdDM *> *banners;

// 投资活动
@property (nonatomic, copy) NSArray<InvestActivityDM *> *ativity;

@property (nonatomic, strong) BannerAdDM *modelBanner;
@property (nonatomic, strong) makeCopperListReq *modelLeft;
@property (nonatomic, strong) makeCopperListReq *modelRight;

@property (nonatomic, readonly) UITableView *tableView;

@end
