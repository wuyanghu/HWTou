//
//  TopicTitleListCollectionViewCell.m
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TopicTitleListCollectionViewCell.h"
#import "PublicHeader.h"

@implementation TopicTitleListView

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
    [self addSubview:self.nickLabel];
    [self addSubview:self.playBtn];
    [self addSubview:self.playNumLabel];
    [self addSubview:self.commentBtn];
    [self addSubview:self.commentNumLabel];
    
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
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLael);
        make.bottom.equalTo(self.headerView);
        make.height.equalTo(12);
        make.width.equalTo(100);
    }];;
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(12, 12));
        make.right.equalTo(self.playNumLabel.mas_left).offset(-5);
        make.bottom.equalTo(self.headerView);
    }];
    
    [self.playNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.playBtn);
        make.right.equalTo(self.commentBtn.mas_left).offset(-5);
        make.bottom.equalTo(self.playBtn);
        make.width.equalTo(30);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.playBtn);
        make.right.equalTo(self.commentNumLabel.mas_left).offset(-5);
        make.bottom.equalTo(self.commentNumLabel);
    }];
    
    [self.commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.playNumLabel);
        make.bottom.equalTo(self.playBtn);
        make.right.equalTo(self).offset(-10);
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromHex(0xF3F4F6);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(0.5);
        make.bottom.equalTo(self).offset(-0.5);
    }];
}

- (void)buttonSelected:(UIButton *)button{
    [_btnSelectedDelegate buttonSelected:button];
}

- (void)setTopicListModel:(MyTopicListModel *)topicListModel{
    _topicListModel = topicListModel;
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:topicListModel.bmg]];
    self.isRedIV.hidden = !topicListModel.isRed;
    self.nickLabel.text = topicListModel.nickname;;
    self.playNumLabel.text = [NSString stringWithFormat:@"%ld",topicListModel.lookNum];
    self.commentNumLabel.text = [NSString stringWithFormat:@"%ld",topicListModel.commentNum];
    self.titleLael.text = topicListModel.title;
    self.subTitleLael.text = topicListModel.content;
}

#pragma mark - getter setter

- (UILabel *)nickLabel{
    if (!_nickLabel) {
        _nickLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8E8F91) size:12];
    }
    return _nickLabel;
}

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

- (UILabel *)commentNumLabel{
    if (!_commentNumLabel) {
        _commentNumLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8E8F91) size:9];
    }
    return _commentNumLabel;
}

- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
        _commentBtn.tag = commentBtnType;
        [_commentBtn setImage:[UIImage imageNamed:@"ht_comment"] forState:UIControlStateNormal];
    }
    return _commentBtn;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
        _playBtn.tag = playBtnType;
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
@end

@implementation TopicTitleListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _topicTitleListView = [[TopicTitleListView alloc] initWithFrame:CGRectZero];
        [self addSubview:_topicTitleListView];
        
        [_topicTitleListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}
@end

@implementation TopicTitleListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _topicTitleListView = [[TopicTitleListView alloc] initWithFrame:CGRectZero];
        [self addSubview:_topicTitleListView];
        
        [_topicTitleListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end

