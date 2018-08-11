//
//  ActivityContentView.h
//  HWTou
//
//  Created by mac on 2017/3/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerAdDM;
@class ActivityCategoryDM;

@protocol ActivityContentViewDelegate <NSObject>

@optional
// 点击分类事件
- (void)onSelectCategoryAtIndex:(NSInteger)index;

@end

@interface ActivityContentView : UIView

@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic, weak) id<ActivityContentViewDelegate> delegate;

@property (nonatomic, copy) NSArray *listData;

// 商品分类
@property (nonatomic, copy) NSArray<ActivityCategoryDM *> *categorys;

// 横幅广告
@property (nonatomic, copy) NSArray<BannerAdDM *> *banners;

@end
