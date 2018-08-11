//
//  RotCollectionCell.h
//  HWTou
//
//  Created by robinson on 2017/12/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "TopicWorkDetailModel.h"
#import "GuessULikeModel.h"
#import "HorizontalListView.h"

@protocol RotButtonSelectedDelegate
- (void)buttonSelected:(UIButton *)button indexPath:(NSIndexPath *)indexPath;
@end

@interface RotCollectionCell : UIView

@end

@interface RotCollectHeaderView:UICollectionReusableView

@property (nonatomic,copy) NSString * titleLabelText;
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) CustomButton * moreBtn;
@property (nonatomic,assign) id<RotButtonSelectedDelegate> rotBtnDelegate;
@property (nonatomic,assign) id<TopicButtonSelectedDelegate> topicBtnDelegate;
@end

@interface RotCollectFooterView:UICollectionReusableView
@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) CustomButton * exchangeBtn;//换一批
@property (nonatomic,assign) id<RotButtonSelectedDelegate> btnDelegate;
@end

@interface RotCollectCell:UICollectionViewCell

@property (nonatomic,strong) UIImageView * headerView;//头像
@property (nonatomic, strong) UIImageView *isRedIV;
@property (nonatomic,strong) UIButton * playBtn;//播放按钮
@property (nonatomic,strong) UILabel * playNumLabel;//播放数量
@property (nonatomic,strong) UILabel * titleLael;//标题

@property (nonatomic,strong) MyTopicListModel * topicListModel;
@property (nonatomic,strong) GuessULikeModel * likeModel;

@end

//水平
@interface RotCollectHorizontalCell:UICollectionViewCell
@property (nonatomic,strong) HorizontalListView * listView;
@end
