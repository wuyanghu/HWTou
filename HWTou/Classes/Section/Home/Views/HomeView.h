//
//  HomeView.h
//  HWTou
//
//  Created by pengpeng on 17/3/9.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewDelegate.h"

@class BannerAdDM;
@class FloorListDM;
@class HomeNoticeDM;
@class HomeConfigDM;

@interface HomeView : UIView

@property (nonatomic, readonly) UICollectionView  *collectionView;
@property (nonatomic, copy) NSArray<BannerAdDM *> *banners;
@property (nonatomic, copy) NSArray<FloorListDM *> *floors;
@property (nonatomic, copy) NSArray<HomeNoticeDM *> *notices;
@property (nonatomic, copy) NSArray<HomeConfigDM *> *config;

@property (nonatomic, weak) id<HomeViewDelegate> delegate;

@end
