//
//  HistoryTopTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/1/4.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HistoryTopModel.h"
#import "VoiceReplyView.h"

@protocol HistoryTopTableViewCellDelegate
- (void)praise:(NSInteger)commentId;//点赞
- (void)voiceReplyViewClick:(HistoryTopModel * )topModel;
- (void)topBtnClick:(HistoryTopModel * )topModel;//置顶
@end


@interface HistoryTopTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianzan;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet VoiceReplyView *voiceReplyView;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;


@property (nonatomic,strong) HistoryTopModel * topModel;
@property (nonatomic,assign) BOOL isClickPlay;//点击是否播放
@property (nonatomic,assign) BOOL isHistoryTop;//是否历史置顶

@property (nonatomic,weak) id<HistoryTopTableViewCellDelegate> topDelegate;
@end
