//
//  AudioPlayerInfoCell.h
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerDetailViewModel.h"

@protocol PraiseChannelDelegate
- (void)praiseChannelAction;
- (void)imgBtnActionWithUserId:(int)userId;
- (void)contentImgBtnAction:(NSArray *)imgsArr index:(NSInteger)index;
@end

@interface AudioPlayerInfoCell : UITableViewCell
@property (nonatomic,weak) id<PraiseChannelDelegate> delegate;
@property (nonatomic,strong) PlayerDetailViewModel * viewModel;
+ (NSString *)cellReuseIdentifierInfo;

/*
 * isTopic:只有话题可以点击头像打开用户卡片
 */
- (void)bind:(PlayerDetailViewModel *)viewModel isTopic:(BOOL)isTopic;
//刷新点赞数
- (void)refreshZanLab;
@end
