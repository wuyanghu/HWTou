//
//  ComFloorView.h
//  HWTou
//
//  Created by pengpeng on 17/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FloorListDM;
@class ComFloorView;

@protocol FloorViewDelegate <NSObject>

@optional
// 头部视图
- (void)floorView:(ComFloorView *)floorView topReusableView:(UICollectionReusableView *)topView;

- (void)floorScrollViewDidScroll:(UIScrollView *)scrollView;

@end

@protocol FloorViewDataSource <NSObject>

@optional
// 头部视图的高度
- (CGSize)floorViewTopSize:(ComFloorView *)floorView;

// 头部视图类
- (Class)floorViewTopRegisterClass:(ComFloorView *)floorView;

@end

@interface ComFloorView : UIView

@property (nonatomic, readonly) UICollectionView  *collectionView;
@property (nonatomic, copy) NSArray<FloorListDM *> *listData;

@property (nonatomic, weak) id<FloorViewDataSource> dataSource;
@property (nonatomic, weak) id<FloorViewDelegate> delegate;

- (void)reloadFloorData;

@end
