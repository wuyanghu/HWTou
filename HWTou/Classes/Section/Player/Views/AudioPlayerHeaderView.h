//
//  AudioPlayerHeaderView.h
//  HWTou
//
//  Created by Reyna on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerDetailViewModel.h"

@class PlayHighInfoViewModel,HistoryTopModel;

@protocol AudioPlayerHeaderViewDelegate
- (void)programClick;//节目单
- (void)hignInfoClick;//重要信息
@end

@interface AudioPlayerHeaderView : UIView
@property (nonatomic,weak) id<AudioPlayerHeaderViewDelegate> headerViewDelegate;

@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) HistoryTopModel * topModel;

- (instancetype)initWithFrame:(CGRect)frame progressBarHidden:(BOOL)isHidden;

- (void)bind:(PlayerDetailViewModel *)viewModel playing:(NSString *)playing flag:(int)flag;
//重要信息
- (void)bindHighInfoView:(HistoryTopModel *)topModel;

@end
