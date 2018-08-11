//
//  HomeHeaderView.h
//  HWTou
//
//  Created by pengpeng on 17/3/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewDelegate.h"

@class BannerAdDM;
@class HomeNoticeDM;
@class HomeConfigDM;

@interface HomeHeaderView : UICollectionReusableView

@property (nonatomic, weak) id<HomeViewDelegate> delegate;

@property (nonatomic, copy) NSArray<BannerAdDM *>   *banners;
@property (nonatomic, copy) NSArray<HomeNoticeDM *> *notices;
@property (nonatomic, copy) NSArray<HomeConfigDM *> *config;

@end
