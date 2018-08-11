//
//  HistoryTopTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/1/4.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "HistoryTopTableViewCell.h"
#import "PublicHeader.h"

@interface HistoryTopTableViewCell()<VoiceReplyViewDelegate>

@end

@implementation HistoryTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.headerImageView setContentMode:UIViewContentModeScaleAspectFill];
    CAShapeLayer *shape = [BasisUITool headPortraitRoundProcessing:40];
    [self.headerImageView.layer setMask:shape];
    self.voiceReplyView.voiceReplyDelegate = self;
    
    [self.praiseBtn setImage:[UIImage imageNamed:@"givethethumbsup_icon_clicked"] forState:UIControlStateSelected];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.topBtn setTitleColor:UIColorFromHex(0xFF6767) forState:UIControlStateNormal];
    [self.topBtn setTitleColor:UIColorFromHex(0x8E8F91) forState:UIControlStateSelected];
    [self.topBtn setTintColor:[UIColor clearColor]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopModel:(HistoryTopModel *)topModel{
    _topModel = topModel;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:topModel.avater]];
    self.nickNameLabel.text = topModel.nickName;
    self.dianzan.text = [NSString stringWithFormat:@"%ld",topModel.praiseNum];
    self.createTimeLabel.text = topModel.createTime;
    self.voiceReplyView.voiceDuration = (int)topModel.duration;
    [self.voiceReplyView registerWithVoiceUrl:topModel.comUrl];
    self.voiceReplyView.isClickPlay = self.isClickPlay;
    [self.praiseBtn setSelected:topModel.isPraise==1?YES:NO];
    
    if (_isHistoryTop) {
        [self.topBtn setTitle:topModel.isTop==1?@"已置顶":@"置顶" forState:UIControlStateNormal];
        self.topBtn.selected = topModel.isTop==1;
    }else{
        self.topBtn.hidden = YES;
    }
    
}

- (IBAction)praiseAction:(id)sender {
    if (_topDelegate) {
        [_topDelegate praise:_topModel.comId];
    }
}

- (void)voiceReplyViewClick{
    if (_topDelegate) {
        [_topDelegate voiceReplyViewClick:_topModel];
    }
}

- (IBAction)topBtnClick:(id)sender {
    if (_topDelegate) {
        [_topDelegate topBtnClick:_topModel];
    }
}


@end
