//
//  PersonDynamicStateCell.m
//  HWTou
//
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonDynamicStateCell.h"
#import "PublicHeader.h"
#import "TopicWorkDetailModel.h"
#import "AudioUtil.h"

#define my_icon_zan @"my_icon_zan"
#define icon_viewingquantity @"icon_viewingquantity"

@interface PersonDynamicStateCell()

@property (nonatomic,strong) UIImageView * headerImageView;//头像
@property (nonatomic,strong) UILabel * nicknameLabel;//昵称
@property (nonatomic,strong) UIButton * likeBtn;//点赞
@property (nonatomic,strong) UILabel * likeNumLabel;//点赞数量

@property (nonatomic,strong) UILabel * commentLabel;//文字评论
@property (nonatomic,strong) UIButton * commentBtn;//语音评论
@property (nonatomic,strong) UIImageView * commentPlayImageView;
@property (nonatomic,strong) UILabel * commentTimeLabel;//时长


//////评论内容
@property (nonatomic,strong) UIImageView * contentHeaderImageView;//内容头像
@property (nonatomic,strong) UILabel * contentProgramNameLabel;//节目名称
@property (nonatomic,strong) UILabel * contentPlayStateLabel;//节目播放状态
@property (nonatomic,strong) UIButton * contentPlayStateBtn;//节目播放状态按钮
@property (nonatomic,strong) UILabel * contentPlayNumLabel;//节目播放数量

@end

@implementation PersonDynamicStateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self drawView];
    }
    return self;
}

- (void)drawView{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除点击效果
    
    [self addSubview:self.headerImageView];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.likeBtn];
    [self addSubview:self.likeNumLabel];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(10);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView).offset(12);
        make.left.equalTo(self.headerImageView.mas_right).offset(5);
        make.width.equalTo(200);
        make.height.equalTo(14);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.likeNumLabel.mas_left).offset(-5);
        make.top.equalTo(self.nicknameLabel);
        make.size.equalTo(CGSizeMake(13, 14));
    }];
    
    [self.likeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(30, 10));
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.nicknameLabel).offset(2);
    }];
    
    [self addSubview:self.commentLabel];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nicknameLabel);
        make.top.equalTo(self.headerImageView.mas_bottom);
        make.right.equalTo(self).offset(-8);
        make.height.lessThanOrEqualTo(40);
    }];
    
    [self addSubview:self.commentBtn];
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentLabel).offset(40);
        make.size.equalTo(CGSizeMake(159, 30));
        make.top.equalTo(self.commentLabel).offset(-8);
    }];
    
    [self.commentPlayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(14, 18));
        make.top.equalTo(self.commentBtn).offset(5);
        make.left.equalTo(self.commentBtn).offset(21);
    }];
    
    [self.commentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(30, 12));
        make.centerY.equalTo(self.commentBtn);
        make.right.equalTo(self.commentBtn.mas_right).offset(-15);
    }];
    
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColorFromHex(0xF3F4F6);
    [bgView.layer setCornerRadius:10];
    [bgView.layer setMasksToBounds:YES];
    [self addSubview:bgView];
    
    [self addSubview:self.contentHeaderImageView];
    [self addSubview:self.contentProgramNameLabel];
    [self addSubview:self.contentPlayStateLabel];
    [self addSubview:self.contentPlayStateBtn];
    [self addSubview:self.contentPlayNumLabel];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentLabel);
        make.top.equalTo(self.commentLabel.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(92);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    [self.contentHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(70, 70));
        make.left.equalTo(bgView).offset(30);
        make.top.equalTo(bgView).offset(12);
    }];
    
    [self.contentProgramNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentHeaderImageView.mas_right).offset(10);
        make.top.equalTo(self.contentHeaderImageView);
        make.height.equalTo(14);
        make.right.equalTo(bgView).offset(-5);
    }];
    
    [self.contentPlayStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentProgramNameLabel);
        make.top.equalTo(self.contentProgramNameLabel.mas_bottom).offset(14);
        make.height.equalTo(14);
        make.right.equalTo(bgView).offset(-5);
    }];
    
    [self.contentPlayStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(7, 7));
        make.left.equalTo(self.contentPlayStateLabel);
        make.top.equalTo(self.contentPlayStateLabel.mas_bottom).offset(18);
    }];
    
    [self.contentPlayNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentPlayStateBtn);
        make.left.equalTo(self.contentPlayStateBtn.mas_right).offset(5);
        make.height.equalTo(7);
    }];
    
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromHex(0xF3F4F6);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.size.equalTo(CGSizeMake(kMainScreenWidth, 0.5));
        make.bottom.equalTo(self).offset(-0.5);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)buttonSelected:(UIButton *)button
{
    if (button.tag == likeBtnType) {//点赞广播，话题等
        [_dynamicDelegate likeButtonSelected:_detailModel];
    }else if (button.tag == contentPlayStateBtnType){//播放广播
        
    }else if(button.tag == commentPlayBtnType){//播放语音
        [[AudioUtil sharedInstance] playReplyVoiceWithVoicePath:_detailModel.markUrl];
    }
}

- (void)changeLabelColor:(UILabel *)label{
    if (label.text.length<=4) {
        return;
    }
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromHex(0xFF6767)
                          range:NSMakeRange(0, 4)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromHex(0x2B2B2B)
                          range:NSMakeRange(4, label.text.length-4)];
    [label setAttributedText:AttributedStr];
}

#pragma mark - setter
- (void)setDetailModel:(UserDetailModel *)detailModel{
    _detailModel = detailModel;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.avater]];
    self.nicknameLabel.text = detailModel.nickname;
    self.likeNumLabel.text = [NSString stringWithFormat:@"%ld",detailModel.praise];
    
    if (detailModel.commentFlag == 2) {
        if (![detailModel.markText containsString:@"[图片]"]) {
            detailModel.markText = [NSString stringWithFormat:@"%@[图片]",detailModel.markText];
        }
        
    }else if(detailModel.commentFlag == 3){
        if (![detailModel.markText containsString:@"[视频]"]) {
            detailModel.markText = [NSString stringWithFormat:@"%@[视频]",detailModel.markText];
        }
    }
    if (detailModel.markState == 1) {//发表话题
        self.commentLabel.text = detailModel.markText;
        self.likeBtn.selected = NO;
    }else if (detailModel.markState == 2){//评论
        self.commentLabel.text = [NSString stringWithFormat:@"评论了:%@",detailModel.markText];
        [self changeLabelColor:self.commentLabel];
        self.likeBtn.selected = [detailModel getIsPraise];
    }else{//回复
        self.commentLabel.text = [NSString stringWithFormat:@"回复了:%@",detailModel.markText];
        [self changeLabelColor:self.commentLabel];
        self.likeBtn.selected = [detailModel getIsPraise];
    }
    
    if (detailModel.markUrl != nil && ![detailModel.markUrl isEqualToString:@""]) {
        self.commentBtn.hidden = NO;
        self.commentTimeLabel.text = [NSString stringWithFormat:@"%ld\"",_detailModel.commentDuration];
    }else{
        self.commentBtn.hidden = YES;
    }
    
    [self.contentHeaderImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.bmg]];
    self.contentProgramNameLabel.text = detailModel.title;
    if (detailModel.flag == 1) {//广播
        self.contentPlayStateLabel.hidden = NO;
        self.contentPlayStateLabel.text = detailModel.playing;
    }else if (detailModel.flag == 2){//话题
        self.contentPlayStateLabel.hidden = YES;
    }else if(detailModel.flag == 3){//聊吧
        self.contentPlayStateLabel.hidden = YES;
    }
    self.contentPlayNumLabel.text = [NSString stringWithFormat:@"%ld",detailModel.lookNum];
}
#pragma mark - getter


- (UILabel *)contentPlayNumLabel{
    if (!_contentPlayNumLabel) {
        _contentPlayNumLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8E8F91) size:9];
    }
    return _contentPlayNumLabel;
}

- (UIButton *)contentPlayStateBtn{
    if (!_contentPlayStateBtn) {
        _contentPlayStateBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
        _contentPlayStateBtn.tag = contentPlayStateBtnType;
        [_contentPlayStateBtn setBackgroundImage:[UIImage imageNamed:icon_viewingquantity] forState:UIControlStateNormal];
    }
    return _contentPlayStateBtn;
}

- (UILabel *)contentPlayStateLabel{
    if (!_contentPlayStateLabel) {
        _contentPlayStateLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x595656) size:14];
    }
    return _contentPlayStateLabel;
}

- (UILabel *)contentProgramNameLabel{
    if (!_contentProgramNameLabel) {
        _contentProgramNameLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:15];
    }
    return _contentProgramNameLabel;
}

- (UIImageView *)contentHeaderImageView{
    if (!_contentHeaderImageView) {
        _contentHeaderImageView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_SYSTEM_AVATAR withIsUserInteraction:NO];
        _contentHeaderImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _contentHeaderImageView;
}

- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] init];
        [_commentBtn setBackgroundImage:[UIImage imageNamed:@"ht_qipao"] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.tag = commentPlayBtnType;
        
        _commentPlayImageView = [BasisUITool getImageViewWithImage:@"voice" withIsUserInteraction:NO];
        [_commentBtn addSubview:_commentPlayImageView];
        
        _commentTimeLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xffffff) size:14];
        [_commentBtn addSubview:_commentTimeLabel];
        
    }
    return _commentBtn;
}


- (UILabel *)commentLabel{
    if (!_commentLabel) {
        _commentLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2b2b2b) size:12];
        _commentLabel.numberOfLines = 0;
    }
    return _commentLabel;
}
- (UILabel *)likeNumLabel{
    if (!_likeNumLabel) {
        _likeNumLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x707070) size:12];
    }
    return _likeNumLabel;
}

- (UIButton *)likeBtn{
    if (!_likeBtn) {
        _likeBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
        _likeBtn.tag = likeBtnType;
        [_likeBtn setImage:[UIImage imageNamed:@"givethethumbsup_icon_click"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"givethethumbsup_icon_clicked"] forState:UIControlStateSelected];
    }
    return _likeBtn;
}

- (UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8E8F91) size:14];
    }
    return _nicknameLabel;
}

- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_SYSTEM_AVATAR withIsUserInteraction:NO];
        [_headerImageView setContentMode:UIViewContentModeScaleAspectFill];
        CAShapeLayer *shape = [BasisUITool headPortraitRoundProcessing:40];
        [_headerImageView.layer setMask:shape];
    }
    return _headerImageView;
}

@end

