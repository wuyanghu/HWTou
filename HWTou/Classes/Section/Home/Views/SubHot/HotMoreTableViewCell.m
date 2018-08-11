//
//  HotMoreTableViewCell.m
//  HWTou
//
//  Created by robinson on 2017/12/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HotMoreTableViewCell.h"
#import "PublicHeader.h"
#import "DemoTextMenuConfig.h"

@implementation HotMoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self drawView];
    }
    return self;
}

- (void)drawView{
    
    [self addSubview:self.headerView];
    [self addSubview:self.isRedIV];
    [self addSubview:self.titleLael];
    [self addSubview:self.subTitleLael];
    [self addSubview:self.playBtn];
    [self addSubview:self.playNumLabel];
    [self addSubview:self.onlineLabel];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(10);
        make.size.equalTo(CGSizeMake(70, 70));
    }];
    
    [self.isRedIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.headerView);
        make.size.equalTo(self.headerView);
    }];
    
    [self.titleLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView);
        make.left.equalTo(self.headerView.mas_right).offset(10);
        make.right.equalTo(self).offset(-60);
        make.height.equalTo(14);
    }];
    
    [self.subTitleLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLael);
        make.top.equalTo(self.titleLael.mas_bottom).offset(14);
        make.height.equalTo(13);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(12, 12));
        make.left.equalTo(self.titleLael);
        make.bottom.equalTo(self.headerView);
    }];
    
    [self.playNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.playBtn);
        make.left.equalTo(self.playBtn.mas_right).offset(5);
        make.bottom.equalTo(self.playBtn);
        make.right.equalTo(self).offset(-10);
    }];
    
    [self.onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(self).offset(21);
        make.bottom.equalTo(self.headerView.mas_bottom);
    }];
}

- (void)buttonSelected:(UIButton *)button{
//    [_btnSelectedDelegate buttonSelected:button];
}

- (void)setUlistModel:(GuessULikeModel *)ulistModel{
    _ulistModel = ulistModel;

    [self.headerView sd_setImageWithURL:[NSURL URLWithString:ulistModel.bmgs]];
    self.isRedIV.hidden = !ulistModel.isRed;
    self.playNumLabel.text = [NSString stringWithFormat:@"%ld",ulistModel.lookNum];
    if (ulistModel.flag == 1) {//广播
        self.titleLael.text = ulistModel.name;
        self.subTitleLael.text = ulistModel.playing;
    }else if (ulistModel.flag == 2){//话题
        self.titleLael.text = ulistModel.title;
        self.subTitleLael.text = ulistModel.content;
    }else if (ulistModel.flag == 3){//聊吧
        self.titleLael.text = ulistModel.name;
        self.subTitleLael.text = ulistModel.content;
    }
    
}

- (void)setMyChatsTModel:(GetMyChatsTModel *)myChatsTModel{
    _myChatsTModel = myChatsTModel;
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:myChatsTModel.bmgs]];
    self.playNumLabel.text = [NSString stringWithFormat:@"%ld",myChatsTModel.lookNum];
    self.titleLael.text = myChatsTModel.name;
    self.subTitleLael.text = myChatsTModel.content;
    
    self.onlineLabel.hidden = NO;
    if (myChatsTModel.isOnline == 1) {
        self.onlineLabel.text = [NSString stringWithFormat:@"%@ 在线",myChatsTModel.anchorName];
        self.onlineLabel.textColor = UIColorFromHex(0xff4d49);
    }else{
        self.onlineLabel.text = @"暂无主播";
        self.onlineLabel.textColor = UIColorFromHex(0x8F8F8F);
    }
}

+(NSString *)cellReuseIdentifierInfo{
    return @"HotMoreTableViewCell";
}

#pragma mark - getter setter

- (UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [BasisUITool getImageViewWithImage:@"avatar_sample_15" withIsUserInteraction:NO];
        _headerView.contentMode = UIViewContentModeScaleToFill;
    }
    return _headerView;
}

- (UIImageView *)isRedIV {
    if (!_isRedIV) {
        _isRedIV = [BasisUITool getImageViewWithImage:@"rm_img_hb" withIsUserInteraction:NO];
        _isRedIV.hidden = YES;
    }
    return _isRedIV;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
        [_playBtn setImage:[UIImage imageNamed:@"content_icon"] forState:UIControlStateNormal];
    }
    return _playBtn;
}

- (UILabel *)playNumLabel{
    if (!_playNumLabel) {
        _playNumLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8e8f91) size:9];
    }
    return _playNumLabel;
}

- (UILabel *)titleLael{
    if (!_titleLael) {
        _titleLael = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2b2b2b) size:15];
    }
    return _titleLael;
}


- (UILabel *)subTitleLael{
    if(!_subTitleLael){
        _subTitleLael = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x595656) size:14];
    }
    return _subTitleLael;
}

- (UILabel *)onlineLabel{
    if (!_onlineLabel) {
        _onlineLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x595656) size:14];
        _onlineLabel.hidden = YES;
    }
    return _onlineLabel;
}

@end
