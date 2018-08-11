//
//  HorizontalListView.m
//  HWTou
//
//  Created by robinson on 2017/12/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HorizontalListView.h"
#import "PublicHeader.h"
#import "GuessULikeModel.h"
#import "PlayerHistoryModel.h"

@implementation HorizontalListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
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
    [self addSubview:self.rightPlayBtn];
    
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
        make.size.equalTo(CGSizeMake(9, 9));
        make.left.equalTo(self.titleLael);
        make.bottom.equalTo(self.headerView).offset(-7.5);
    }];
    
    [self.playNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playBtn);
        make.left.equalTo(self.playBtn.mas_right).offset(5);
        make.bottom.equalTo(self.playBtn);
        //宽带自适应
    }];
    
    [self.rightPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(35, 35));
        make.right.equalTo(self).offset(-16);
        make.top.equalTo(self.headerView);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = UIColorFromHex(0xF3F4F6);
    [self addSubview:_lineView];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right);
        make.width.equalTo(kMainScreenWidth);
        make.height.equalTo(0.5);
        make.bottom.equalTo(self).offset(-0.5);
    }];
}

- (void)setLikeModel:(GuessULikeModel *)likeModel isShowLine:(BOOL)isShowLine{
    self.lineView.hidden = isShowLine;
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:likeModel.bmgs]];
    self.isRedIV.hidden = !likeModel.isRed;
    self.playNumLabel.text = [NSString stringWithFormat:@"%ld",likeModel.lookNum];
    if (likeModel.flag == 1) {
        self.titleLael.text = likeModel.name;
        self.subTitleLael.text = likeModel.playing;
    }else if (likeModel.flag == 2){
        self.titleLael.text = likeModel.title;
        self.subTitleLael.text = likeModel.content;
    }else if(likeModel.flag == 3){
        self.titleLael.text = likeModel.name;
        self.subTitleLael.text = likeModel.content;
    }
}

- (void)setHistoryModel:(PlayerHistoryModel *)historyModel{
    self.lineView.hidden = YES;
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:historyModel.bmg]];
    self.playNumLabel.text = [NSString stringWithFormat:@"%d",historyModel.lookNum];
    if (historyModel.flag == 1) {
        self.titleLael.text = historyModel.name;
        self.subTitleLael.text = historyModel.playing;
    }else if (historyModel.flag == 2){
        self.titleLael.text = historyModel.title;
        self.subTitleLael.text = historyModel.content;
    }else if (historyModel.flag == 3){
        self.titleLael.text = historyModel.name;
        self.subTitleLael.text = [self filterHTML:historyModel.content];
    }

}

- (void)buttonSelected:(UIButton *)button{
    
}

- (NSString *)filterHTML:(NSString *)html {
    
    NSScanner *scanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    while([scanner isAtEnd] == NO) {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
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

- (UIButton *)rightPlayBtn{
    if (!_rightPlayBtn) {
        _rightPlayBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonSelected:)];
        [_rightPlayBtn setBackgroundImage:[UIImage imageNamed:@"content_btn_play"] forState:UIControlStateNormal];
        _rightPlayBtn.hidden = YES;
    }
    return _rightPlayBtn;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"content_icon"] forState:UIControlStateNormal];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
