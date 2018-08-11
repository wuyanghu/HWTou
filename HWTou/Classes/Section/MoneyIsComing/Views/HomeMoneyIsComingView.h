//
//  HomeMoneyIsComingView.h
//  HWTou
//
//  Created by robinson on 2017/11/17.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "TopicWorkDetailModel.h"
#import "GuessULikeViewModel.h"
#import "HomeBanerListViewModel.h"
#import "PlayerDetailViewModel.h"

@protocol HomeMoneyIsComingViewDelegate
- (void)loadHeaderData;
- (void)loadFooterData;
- (void)buttonSelected:(UIButton *)button indexPath:(NSIndexPath *)indexPath;//换一批
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)carouselviewDidSelectItemAtIndex:(NSInteger)index;
@end

@interface HomeMoneyIsComingView : UIView
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic,strong) GuessULikeViewModel * viewModel;
@property (nonatomic,strong) HomeBanerListViewModel * bannerListViewModel;
@property (nonatomic,strong) PlayerDetailViewModel * detailVM;
@property (nonatomic,weak) id<HomeMoneyIsComingViewDelegate> HomeMoneyIsComingViewDelegate;
- (void)refreshData;
@end

