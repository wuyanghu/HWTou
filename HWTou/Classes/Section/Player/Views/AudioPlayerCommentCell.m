//
//  AudioPlayerCommentCell.m
//  HWTou
//
//  Created by Reyna on 2017/11/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AudioPlayerCommentCell.h"
#import "PublicHeader.h"
#import "VoiceReplyView.h"
#import "VoiceUtil.h"
#import "CopyLabel.h"

@interface AudioPlayerCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *zanIV;
@property (weak, nonatomic) IBOutlet UILabel *zanNumLab;
@property (weak, nonatomic) IBOutlet CopyLabel *commentLab;
@property (weak, nonatomic) IBOutlet UIView *commetBGView;

@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *revertBtn;
@property (weak, nonatomic) IBOutlet UIImageView *replyBgIV;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;//置顶(只有聊吧有)
@property (nonatomic, strong) VoiceReplyView *voiceReplyView;

@property (nonatomic, strong) PlayerCommentModel *model;
@property (nonatomic, strong) PlayerHistoryModel * historyModel;
@property (nonatomic, assign) int toUid;
@property (nonatomic, assign) int commentId;
@property (nonatomic, assign) int userId;
@property (nonatomic, strong) NSString *voiceUrl;//声音评论地址
@property (nonatomic, strong) NSString *videoUrl;//视频评论地址
@property (nonatomic, strong) NSArray *imgsArr;//图片数组

@end

@implementation AudioPlayerCommentCell

+ (NSString *)cellReuseIdentifierInfo {
    return @"AudioPlayerCommentCell";
}

- (void)bind:(PlayerCommentModel *)model historyModel:(PlayerHistoryModel *)historyModel{
    
    self.model = model;
    self.historyModel = historyModel;
    self.toUid = model.parentUid;
    self.commentId = model.parentCommentId;
    self.userId = model.parentUid;
    self.voiceUrl = model.commentFlag == 1 ? model.commentUrl : nil;
    self.videoUrl = model.commentFlag == 3 ? model.commentUrl : nil;
    self.imgsArr = model.commentFlag == 2 ? model.commentUrlArray : nil;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.avater]];
    self.nameLab.text = model.nickName;
    if (model.isPraise) {
        self.zanIV.image = [UIImage imageNamed:@"gb_btn_zan_down"];
    }
    else {
        self.zanIV.image = [UIImage imageNamed:@"gb_btn_zan"];
    }
    self.zanNumLab.text = [NSString stringWithFormat:@"%d",model.praiseNum];
    self.dateLab.text = model.dateAndReplyNum;
    self.locationLab.text = model.commentLocation;
    
    //评论信息
    if (model.commentFlag == 4) {
        self.commentLab.hidden = YES;
    }else {
       self.commentLab.hidden = [model.commentText isEqualToString:@""] ? YES : NO;
    }
    self.commentLab.frame = CGRectMake(54, 51, kMainScreenWidth - 62, model.commentHeight);
    self.commentLab.text = model.commentText;
    
    //防止重用导致的重复添加(语音信息 & 图片视频)
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[VoiceReplyView class]]) {
            [view removeFromSuperview];
        }
    }
    for (UIView *vi in self.commetBGView.subviews) {
        [vi removeFromSuperview];
    }
    
    if (model.commentFlag == 0) {
        self.commetBGView.hidden = YES;
    }
    else if (model.commentFlag == 1) {
        //flag = 1 含语音类型的cell样式
        self.commentLab.hidden = YES;
        self.commetBGView.hidden = YES;
        
        VoiceReplyView *voiceReplyView = [[VoiceReplyView alloc] initWithFrame:CGRectMake(55, 56, 158, 30)];
        voiceReplyView.voiceDuration = model.duration;
        [voiceReplyView registerWithVoiceUrl:model.commentUrl];
        [self.contentView addSubview:voiceReplyView];
        
        if ([[VoiceUtil sharedInstance] isPlaying] && [[[VoiceUtil sharedInstance] getCurrentPlayUrl] isEqualToString:model.commentUrl]) {
            [voiceReplyView startSelfAnimation];
        }
    }
    else if (model.commentFlag == 2) {
        //flag = 2 含图片类型的cell样式
        self.commetBGView.hidden = NO;
        for (int i=0; i<model.commentUrlArray.count; i++) {
            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imgBtn.frame = CGRectMake((i%3)*(model.imgHeight+10), i/3*(model.imgHeight+10), model.imgHeight, model.imgHeight);
            imgBtn.tag = 1000 + i;
            [imgBtn addTarget:self action:@selector(imgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn sd_setImageWithURL:[NSURL URLWithString:[model.commentUrlArray objectAtIndex:i]] forState:UIControlStateNormal];
            [self.commetBGView addSubview:imgBtn];
        }
        
        //有文字评论的时候为评论高度+15 否则没有15
        if ([model.commentText isEqualToString:@""]) {
            self.commetBGView.frame = CGRectMake(54, 51 + model.commentHeight, kMainScreenWidth - 62, model.imgsHeight);
        }
        else {
            self.commetBGView.frame = CGRectMake(54, 51 + model.commentHeight + 15, kMainScreenWidth - 62, model.imgsHeight);
        }
    }
    else if (model.commentFlag == 3) {
        //flag = 3 含视频类型的cell样式
        self.commetBGView.hidden = NO;
        UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        videoBtn.frame = CGRectMake(0, 0, 190, 110);
        [videoBtn sd_setImageWithURL:[NSURL URLWithString:model.commentImgUrl] forState:UIControlStateNormal];
        [videoBtn addTarget:self action:@selector(videoBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.commetBGView addSubview:videoBtn];
        
        UIImageView *playIcon = [[UIImageView alloc] initWithFrame:CGRectMake(80, 40, 30, 30)];
        playIcon.image = [UIImage imageNamed:@"reply_video_play"];
        [videoBtn addSubview:playIcon];
        
        //有文字评论的时候为评论高度+15 否则没有15
        if ([model.commentText isEqualToString:@""]) {
            self.commetBGView.frame = CGRectMake(54, 51 + model.commentHeight, kMainScreenWidth - 62, 110);
        }
        else {
            self.commetBGView.frame = CGRectMake(54, 51 + model.commentHeight + 15, kMainScreenWidth - 62, 110);
        }
    }
    else if (model.commentFlag == 4) {
        //flag = 4 红包样式
        self.commetBGView.hidden = NO;
        UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        videoBtn.frame = CGRectMake(0, 0, 193, 91);
        if (model.redState == 0) {
            [videoBtn setImage:[UIImage imageNamed:@"ht_img_wchb"] forState:UIControlStateNormal];
        }else if (model.redState == 1) {
            [videoBtn setImage:[UIImage imageNamed:@"ht_img_ylwhb"] forState:UIControlStateNormal];
        }else if (model.redState == 2) {
            [videoBtn setImage:[UIImage imageNamed:@"ht_img_ychb"] forState:UIControlStateNormal];
        }else if (model.redState == 3) {
            [videoBtn setImage:[UIImage imageNamed:@"ht_img_ygqhb"] forState:UIControlStateNormal];
        }
        [videoBtn addTarget:self action:@selector(getRedPacketAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.commetBGView addSubview:videoBtn];
        
        self.commetBGView.frame = CGRectMake(54, 56, 193, 91);
    }
    
    self.deleteBtn.hidden = model.state ? NO : YES;
    self.replyBgIV.hidden = model.replyNum ? NO : YES;
    self.replyBgIV.frame = CGRectMake(54, model.cellTotalHeight - model.replyTotalHeight - 5, kMainScreenWidth - 66, model.replyTotalHeight);
    self.locationLab.hidden = [model.commentLocation isEqualToString:@""] ? YES : NO;
    
    //防止重用导致的重复添加(回复信息)
    for (UIView *vi in self.replyBgIV.subviews) {
        [vi removeFromSuperview];
    }
    if (model.replyNum) {
        
        CopyLabel *replyLab = [[CopyLabel alloc] initWithFrame:CGRectMake(10, 18, kMainScreenWidth - 92, model.subModel.first_replyHeight)];
        replyLab.text = model.subModel.first_replyString;
        replyLab.font = SYSTEM_FONT(14);
//        replyLab.textColor = UIColorFromHex(0xde5e5c);
        replyLab.textColor = UIColorFromHex(0x2b2b2b);
        replyLab.numberOfLines = 0;
        [self.replyBgIV addSubview:replyLab];
        
        if (model.subModel.commentFlag == 1) {
            VoiceReplyView *voiceReplyView = [[VoiceReplyView alloc] initWithFrame:CGRectMake(10 + model.subModel.first_replyWidth + 5, 18, 158, 30)];
            voiceReplyView.voiceDuration = model.subModel.duration;
            [voiceReplyView registerWithVoiceUrl:model.subModel.replyUrl];
            [self.replyBgIV addSubview:voiceReplyView];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 18 + model.subModel.first_replyHeight + 5, model.moreWidth, 21);
        [btn setTitle:[NSString stringWithFormat:@"查看全部%d条回复",model.replyNum] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromHex(0x6293c0) forState:UIControlStateNormal];
        btn.titleLabel.font = SYSTEM_FONT(14);
        [btn addTarget:self action:@selector(moreReply:) forControlEvents:UIControlEventTouchUpInside];
        [self.replyBgIV addSubview:btn];
        
        self.locationLab.frame = CGRectMake(55, model.cellTotalHeight - model.replyTotalHeight - 22 - 17, model.locationWidth, 12);
        self.dateLab.frame = CGRectMake(55, model.cellTotalHeight - model.replyTotalHeight - 22, model.dateWidth, 12);
        self.revertBtn.frame = CGRectMake(kMainScreenWidth - 45, model.cellTotalHeight - model.replyTotalHeight - 26, 40, 20);
        self.deleteBtn.frame = CGRectMake(kMainScreenWidth - 90, model.cellTotalHeight - model.replyTotalHeight - 26, 40, 20);
    }
    else {
        self.locationLab.frame = CGRectMake(55, model.cellTotalHeight - 17 - 17, model.locationWidth, 12);
        self.dateLab.frame = CGRectMake(55, model.cellTotalHeight - 17, model.dateWidth, 12);
        self.revertBtn.frame = CGRectMake(kMainScreenWidth - 45, model.cellTotalHeight - 22, 40, 20);
        self.deleteBtn.frame = CGRectMake(kMainScreenWidth - 90, model.cellTotalHeight - 22, 40, 20);
    }
    
    if (self.historyModel.flag == 3) {
        if (model.commentFlag == 1 && self.historyModel.isWorkChat) {
            self.topBtn.hidden = NO;
        }else{
            self.topBtn.hidden = YES;
        }
        if (self.deleteBtn.hidden) {
            self.topBtn.frame = CGRectMake(kMainScreenWidth - 90, self.revertBtn.frame.origin.y, 50, 20);
        }else{
            self.topBtn.frame = CGRectMake(kMainScreenWidth - 140, self.revertBtn.frame.origin.y, 50, 20);
        }
        if (!self.topBtn.hidden) {
            if (self.model.isTop == 1) {
                [self.topBtn setTitle:@"已置顶" forState:UIControlStateNormal];
                [self.topBtn setTitleColor:UIColorFromHex(0x8E8F91) forState:UIControlStateNormal];
            }else{
                [self.topBtn setTitle:@"置顶" forState:UIControlStateNormal];
                [self.topBtn setTitleColor:UIColorFromHex(0xFF6767) forState:UIControlStateNormal];
            }
        }
    }
    else{
        self.topBtn.hidden = YES;
    }
}

- (void)content:(SubCommentModel *)model historyModel:(PlayerHistoryModel *)historyModel{
    if (self.model == nil) {
        self.model = [PlayerCommentModel new];
        self.model.subModel = model;
    }
    self.historyModel = historyModel;
    
    self.toUid = model.toUid;
    self.commentId = model.replyCommentId;
    self.userId = model.fromUid;
    self.voiceUrl = model.commentFlag == 1 ? model.replyUrl : nil;
    self.videoUrl = model.commentFlag == 3 ? model.replyUrl : nil;
    self.imgsArr = model.commentFlag == 2 ? model.commentUrlArray : nil;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.replyAvater]];
    self.nameLab.text = model.replyNickName;
    if (model.isPraise) {
        self.zanIV.image = [UIImage imageNamed:@"gb_btn_zan_down"];
    }
    else {
        self.zanIV.image = [UIImage imageNamed:@"gb_btn_zan"];
    }
    self.zanNumLab.text = [NSString stringWithFormat:@"%d",model.praiseNum];
    self.locationLab.text = model.commentLocation;
    self.dateLab.text = model.createTime;
    
    self.commentLab.hidden = [model.replyString isEqualToString:@""] ? YES : NO;
    self.commentLab.frame = CGRectMake(54, 51, kMainScreenWidth - 62, model.subReplyHeight);
    self.commentLab.text = model.replyString;
    
    //防止重用导致的重复添加(语音信息 & 图片视频)
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[VoiceReplyView class]]) {
            [view removeFromSuperview];
        }
    }
    for (UIView *vi in self.commetBGView.subviews) {
        [vi removeFromSuperview];
    }
    
    if (model.commentFlag == 0) {
        self.commetBGView.hidden = YES;
    }
    else if (model.commentFlag == 1) {
        //flag = 1 含语音类型的cell样式
        self.commentLab.hidden = YES;
        self.commetBGView.hidden = YES;
        
        VoiceReplyView *voiceReplyView = [[VoiceReplyView alloc] initWithFrame:CGRectMake(55, 56, 158, 30)];
        voiceReplyView.voiceDuration = model.duration;
        [voiceReplyView registerWithVoiceUrl:model.replyUrl];
        [self.contentView addSubview:voiceReplyView];
        
        if ([[VoiceUtil sharedInstance] isPlaying] && [[[VoiceUtil sharedInstance] getCurrentPlayUrl] isEqualToString:model.replyUrl]) {
            [voiceReplyView startSelfAnimation];
        }
    }
    else if (model.commentFlag == 2) {
        //flag = 2 含图片类型的cell样式
        self.commetBGView.hidden = NO;
        for (int i=0; i<model.commentUrlArray.count; i++) {
            UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            imgBtn.frame = CGRectMake((i%3)*(model.imgHeight+10), i/3*(model.imgHeight+10), model.imgHeight, model.imgHeight);
            imgBtn.tag = 1000 + i;
            [imgBtn addTarget:self action:@selector(imgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [imgBtn sd_setImageWithURL:[NSURL URLWithString:[model.commentUrlArray objectAtIndex:i]] forState:UIControlStateNormal];
            [self.commetBGView addSubview:imgBtn];
        }
        
        //有文字评论的时候为评论高度+15 否则没有15
        if ([model.replyText isEqualToString:@""]) {
            self.commetBGView.frame = CGRectMake(54, 52, kMainScreenWidth - 62, model.imgsHeight);
        }
        else {
            self.commetBGView.frame = CGRectMake(54, 52 + model.subReplyHeight + 15, kMainScreenWidth - 62, model.imgsHeight);
        }
    }
    else if (model.commentFlag == 3) {
        //flag = 3 含视频类型的cell样式
        self.commetBGView.hidden = NO;
        UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        videoBtn.frame = CGRectMake(0, 0, 190, 110);
        [videoBtn sd_setImageWithURL:[NSURL URLWithString:model.commentImgUrl] forState:UIControlStateNormal];
        [videoBtn addTarget:self action:@selector(videoBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.commetBGView addSubview:videoBtn];
        
        UIImageView *playIcon = [[UIImageView alloc] initWithFrame:CGRectMake(80, 40, 30, 30)];
        playIcon.image = [UIImage imageNamed:@"reply_video_play"];
        [videoBtn addSubview:playIcon];
        
        //有文字评论的时候为评论高度+15 否则没有15
        if ([model.replyText isEqualToString:@""]) {
            self.commetBGView.frame = CGRectMake(54, 52, kMainScreenWidth - 62, 110);
        }
        else {
            self.commetBGView.frame = CGRectMake(54, 52 + model.subReplyHeight + 15, kMainScreenWidth - 62, 110);
        }
    }
    
    self.locationLab.hidden = [model.commentLocation isEqualToString:@""] ? YES : NO;
    self.replyBgIV.hidden = YES;
    self.deleteBtn.hidden = model.state ? NO : YES;
    self.locationLab.frame = CGRectMake(55, model.subCellHeight - 25 - 17, model.locationWidth, 12);
    self.dateLab.frame = CGRectMake(55, model.subCellHeight - 25, model.dateWidth, 12);
    self.revertBtn.frame = CGRectMake(kMainScreenWidth - 45, model.subCellHeight - 29, 40, 20);
    self.deleteBtn.frame = CGRectMake(kMainScreenWidth - 90, model.subCellHeight - 29, 40, 20);
    
    
    if (self.historyModel.flag == 3) {
        
        if (model.commentFlag == 1 && self.historyModel.isWorkChat) {
            self.topBtn.hidden = NO;
        }else{
            self.topBtn.hidden = YES;
        }
        if (self.deleteBtn.hidden) {
            self.topBtn.frame = CGRectMake(kMainScreenWidth - 90, self.revertBtn.frame.origin.y, 50, 20);
        }else{
            self.topBtn.frame = CGRectMake(kMainScreenWidth - 140, self.revertBtn.frame.origin.y, 50, 20);
        }
        if (!self.topBtn.hidden) {
            if (model.isTop == 1) {
                [self.topBtn setTitle:@"已置顶" forState:UIControlStateNormal];
                [self.topBtn setTitleColor:UIColorFromHex(0x8E8F91) forState:UIControlStateNormal];
            }else{
                [self.topBtn setTitle:@"置顶" forState:UIControlStateNormal];
                [self.topBtn setTitleColor:UIColorFromHex(0xFF6767) forState:UIControlStateNormal];
            }
        }
    }else{
        self.topBtn.hidden = YES;
    }
}

#pragma mark - Action

- (void)moreReply:(UIButton *)btn {
    if (self.delegate) {
        [self.delegate moreBtnAction:self.model];
    }
}

- (IBAction)zanBtnAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate zanBtnActionWithCommentId:self.commentId];
    }
}

- (IBAction)replyBtnAction:(id)sender {
    if (self.delegate) {
        [self.delegate replyBtnActionWithToUid:self.model];
    }
}

- (IBAction)deleteBtnAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate deleteBtnActionWithCommentId:self.commentId];
    }
}

- (IBAction)userInfoAction:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate userInfoActionWithUserId:self.userId];
    }
}

- (IBAction)topBtnAction:(id)sender {
    if (self.delegate) {
        [self.delegate topBtnAction:self.model];
    }
}

- (void)videoBtnAction {
    if (self.delegate) {
        [self.delegate videoBtnAction:self.videoUrl];
    }
}

- (void)imgBtnAction:(UIButton *)btn {
    if (self.delegate) {
        [self.delegate imgBtnAction:self.imgsArr index:btn.tag - 1000];
    }
}

- (void)getRedPacketAction:(UIButton *)btn {
    if (self.delegate) {
        [self.delegate getRedPacketWithCommentModel:self.model];
    }
}

#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[VoiceReplyView class]]) {
            VoiceReplyView *vi = (VoiceReplyView *)view;
            
            if ([[[VoiceUtil sharedInstance] getCurrentPlayUrl] isEqualToString:self.voiceUrl] && [[VoiceUtil sharedInstance] isPlaying]) {
                [vi clearPlay];
            }
        }
    }
}

@end
