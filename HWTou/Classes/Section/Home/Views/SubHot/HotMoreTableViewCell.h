//
//  HotMoreTableViewCell.h
//  HWTou
//
//  Created by robinson on 2017/12/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuessULikeModel.h"
#import "BaseTableViewCell.h"
#import "GRichLabel.h"
#import "GetMyChatsTModel.h"

@interface HotMoreTableViewCell : BaseTableViewCell

@property (nonatomic,strong) UIImageView * headerView;//头像
@property (nonatomic, strong) UIImageView *isRedIV;//红包标识
@property (nonatomic,strong) UILabel * titleLael;//标题
@property (nonatomic,strong) UILabel * subTitleLael;//副标题
@property (nonatomic,strong) UIButton * playBtn;//播放按钮
@property (nonatomic,strong) UILabel * playNumLabel;//播放数量
@property (nonatomic,strong) UILabel * onlineLabel;//有无主播在线

@property (nonatomic,strong) GuessULikeModel * ulistModel;
@property (nonatomic,strong) GetMyChatsTModel * myChatsTModel;

+(NSString *)cellReuseIdentifierInfo;
@end
