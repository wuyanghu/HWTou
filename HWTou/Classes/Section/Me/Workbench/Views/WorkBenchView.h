//
//  WorkBenchView.h
//  HWTou
//
//  Created by robinson on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TopicWorkDetailModel.h"

typedef NS_ENUM(NSInteger,WorkType) {
    workBenchType,//工作台
    workBroadcastType,//广播
    workChatType,//聊吧
};

@protocol WorkBenchViewDelegate
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath workType:(WorkType)workType title:(NSString *)title;
@end

@interface WorkBenchView : UIView

@property (nonatomic,weak) id<WorkBenchViewDelegate> workBenchViewDelegate;
@property (nonatomic,strong) TopicWorkDetailModel *detailModel;
- (instancetype)initWithFrame:(CGRect)frame workType:(WorkType)workType detailModel:(TopicWorkDetailModel *)detailModel;

@end

//基类的头部
@interface BaseWorkHeaderView:UITableViewHeaderFooterView
@property (nonatomic,strong) UIImageView * headerImageView;
@property (nonatomic,strong) UILabel * nicknameLabel;//昵称
@property (nonatomic,strong) UILabel * timeLabel;//时间

@property (nonatomic,strong) UIView * bgView;

@property (nonatomic,strong) TopicWorkDetailModel *detailModel;
@end

//工作台
@class WorkBenchHeaderPlayView;
@interface WorkBenchHeaderView:BaseWorkHeaderView
{
    WorkBenchHeaderPlayView * workBenchHeaderPlayView;
    WorkBenchHeaderPlayView * workBenchHeaderPlay2View;
    WorkBenchHeaderPlayView * workBenchHeaderPlay3View;
}
@end

//工作广播
//@interface WorkBroadcastHeaderView:BaseWorkHeaderView
//
//@end

@interface WorkBenchHeaderPlayView:UIView
@property (nonatomic,strong) UILabel * lastPleyLabel;
@property (nonatomic,strong) UILabel * lastPleyNumLabel;
@property (nonatomic,strong) UILabel * totalPlayLabel;
@end
