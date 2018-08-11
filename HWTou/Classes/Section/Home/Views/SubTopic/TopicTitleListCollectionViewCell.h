//
//  TopicTitleListCollectionViewCell.h
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "TopicWorkDetailModel.h"

@interface TopicTitleListView:UIView

@property (nonatomic,strong) UIImageView * headerView;//头像
@property (nonatomic, strong) UIImageView *isRedIV;//红包标示
@property (nonatomic,strong) UILabel * titleLael;//标题
@property (nonatomic,strong) UILabel * subTitleLael;//副标题
@property (nonatomic,strong) UILabel * nickLabel;//昵称
@property (nonatomic,strong) UIButton * playBtn;//播放按钮
@property (nonatomic,strong) UILabel * playNumLabel;//播放数量
@property (nonatomic,strong) UIButton * commentBtn;//评论按钮
@property (nonatomic,strong) UILabel * commentNumLabel;//评论数量

@property (nonatomic,strong) MyTopicListModel * topicListModel;

@property (nonatomic,assign) id<TopicButtonSelectedDelegate> btnSelectedDelegate;
@end

@interface TopicTitleListCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) TopicTitleListView * topicTitleListView;

@end

@interface TopicTitleListTableViewCell : UITableViewCell

@property (nonatomic,strong) TopicTitleListView * topicTitleListView;

@end

