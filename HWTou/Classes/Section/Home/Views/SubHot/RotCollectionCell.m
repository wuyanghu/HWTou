//
//  RotCollectionCell.m
//  HWTou
//
//  Created by robinson on 2017/12/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RotCollectionCell.h"
#import "PublicHeader.h"

@implementation RotCollectionCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



@implementation RotCollectHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawView];
    }
    return self;
}

- (void)drawView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.moreBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(250, 14));
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(18);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(45, 14));
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.titleLabel);
    }];
    
}

- (void)buttonSelected:(UIButton *)button{
    if (_rotBtnDelegate) {
        [_rotBtnDelegate buttonSelected:button indexPath:_indexPath];
    }
    if (_topicBtnDelegate) {
        [_topicBtnDelegate buttonSelected:button];
    }
}

- (void)setTitleLabelText:(NSString *)titleLabelText{
    self.titleLabel.text = titleLabelText;
    if ([titleLabelText isEqualToString:@"最新主播"] || [titleLabelText isEqualToString:@"今日钱潮"]) {
        self.moreBtn.hidden = YES;
    }else{
        self.moreBtn.hidden = NO;
    }
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2b2b2b) size:15];
        [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    }
    return _titleLabel;
}

- (CustomButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[CustomButton alloc] init];
        [_moreBtn drawMoreBtn];
        _moreBtn.tag = moreBtnType;
        [_moreBtn addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

@end

@implementation RotCollectFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawView];
    }
    return self;
}

- (void)drawView{
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromHex(0xF3F4F6);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.equalTo(self);
        make.height.equalTo(0.5);
    }];
    
    [self addSubview:self.exchangeBtn];
    [self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(lineView.mas_bottom);
        make.width.equalTo(kMainScreenWidth);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColorFromHex(0xF3F4F6);
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.top.equalTo(self.exchangeBtn.mas_bottom);
        make.height.equalTo(10);
    }];
    
}

- (void)buttonSelected:(UIButton *)button{
    [_btnDelegate buttonSelected:button indexPath:_indexPath];
}

- (UIButton *)exchangeBtn{
    if (!_exchangeBtn) {
        _exchangeBtn = [[CustomButton alloc] init];
        [_exchangeBtn drawExchageBtn];
        _exchangeBtn.tag = exchangeBtnType;
        [_exchangeBtn addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeBtn;
}

@end

@implementation RotCollectCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawView];
    }
    return self;
}

- (void)drawView{
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColorFromHex(0x000000);
    bgView.alpha = 0.2;
    
    [self addSubview:self.headerView];
    [self addSubview:self.isRedIV];
    [self addSubview:bgView];
    [self addSubview:self.playBtn];
    [self addSubview:self.playNumLabel];
    [self addSubview:self.titleLael];
    CGSize size = CGSizeMake((kMainScreenWidth-40)/3, (kMainScreenWidth-40)/3);
    if (size.width>113) {
        size = CGSizeMake(113, 113);
    }
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.equalTo(size);
    }];
    
    [self.isRedIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.headerView);
        make.size.equalTo(self.headerView);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.headerView);
        make.height.equalTo(24);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(9, 9));
        make.left.equalTo(self.headerView).offset(5);
        make.bottom.equalTo(self.headerView).offset(-7.5);
    }];
    
    [self.playNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playBtn);
        make.left.equalTo(self.playBtn.mas_right).offset(5);
        make.bottom.equalTo(self.playBtn);
        make.width.mas_greaterThanOrEqualTo(30);
    }];
    
    [self.titleLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headerView);
        make.top.equalTo(self.headerView.mas_bottom).offset(5);
        make.height.equalTo(50);
//        make.bottom.equalTo(self).offset(-5);
    }];
}

- (void)setTopicListModel:(MyTopicListModel *)topicListModel{
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:topicListModel.bmg]];
    self.isRedIV.hidden = !topicListModel.isRed;
    self.playNumLabel.text = [NSString stringWithFormat:@"%ld",topicListModel.lookNum];
    self.titleLael.text = topicListModel.title;
}

- (void)setLikeModel:(GuessULikeModel *)likeModel{
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:likeModel.bmgs]];
    self.isRedIV.hidden = !likeModel.isRed;
    self.playNumLabel.text = [NSString stringWithFormat:@"%ld",likeModel.lookNum];
    if (likeModel.flag == 1) {
        self.titleLael.text = likeModel.name;
    }else if (likeModel.flag == 2){
        self.titleLael.text = likeModel.title;
    }else if(likeModel.flag == 3){
        self.titleLael.text = likeModel.name;
    }
    
}

#pragma mark - click

- (void)buttonSelected:(UIButton *)button{
    
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
        _isRedIV = [BasisUITool getImageViewWithImage:@"rm_img_bighb" withIsUserInteraction:NO];
        _isRedIV.hidden = YES;
    }
    return _isRedIV;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"content_icon_play"] forState:UIControlStateNormal];
    }
    return _playBtn;
}

- (UILabel *)playNumLabel{
    if (!_playNumLabel) {
        _playNumLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xFEFEFE) size:12];
    }
    return _playNumLabel;
}

- (UILabel *)titleLael{
    if (!_titleLael) {
        _titleLael = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x595656) size:12];
        _titleLael.numberOfLines = 0;
        _titleLael.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLael;
}

@end


@implementation RotCollectHorizontalCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.listView];
    }
    return self;
}

- (HorizontalListView *)listView{
    if (!_listView) {
        _listView = [[HorizontalListView alloc] initWithFrame:self.bounds];
    }
    return _listView;
}

@end
