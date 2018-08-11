//
//  HorizontalListView.h
//  HWTou
//
//  Created by robinson on 2017/12/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GuessULikeModel;
@class PlayerHistoryModel;

//共用列表
@interface HorizontalListView : UIView

@property (nonatomic,strong) UIImageView * headerView;//头像
@property (nonatomic, strong) UIImageView *isRedIV;//红包标识
@property (nonatomic,strong) UILabel * titleLael;//标题
@property (nonatomic,strong) UILabel * subTitleLael;//副标题
@property (nonatomic,strong) UIButton * playBtn;//播放按钮
@property (nonatomic,strong) UILabel * playNumLabel;//播放数量
@property (nonatomic,strong) UIButton * rightPlayBtn;//右边大的播放按钮
@property (nonatomic,strong) UIView * lineView;
- (void)setLikeModel:(GuessULikeModel *)likeModel isShowLine:(BOOL)isShowLine;
@property (nonatomic,strong) PlayerHistoryModel * historyModel;
@end
