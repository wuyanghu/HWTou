//
//  PersonInfoViewTableViewCell.m
//  HWTou
//
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonInfoViewTableViewCell.h"
#import "PublicHeader.h"

@interface PersonInfoViewTableViewCell()

@property (nonatomic,strong) UIImageView * headerImageView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * subtitleTitleLabel;

@end

@implementation PersonInfoViewTableViewCell

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleTitleLabel];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(10);
        make.size.equalTo(CGSizeMake(48, 48));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView).offset(10);
        make.left.equalTo(self.headerImageView.mas_right).offset(10);
        make.right.equalTo(self);
        make.height.equalTo(14);
    }];
    
    [self.subtitleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.equalTo(10);
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

#pragma mark - setter

- (void)setUersListDM:(FocusUserListDM *)uersListDM{
    _uersListDM = uersListDM;
    self.titleLabel.text = uersListDM.nickname;
    self.subtitleTitleLabel.text = uersListDM.sign;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:uersListDM.headUrl]];
}

#pragma mark - getter

- (UILabel *)subtitleTitleLabel{
    if (!_subtitleTitleLabel) {
        _subtitleTitleLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8E8F91) size:10];
    }
    return _subtitleTitleLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:16];
    }
    return _titleLabel;
}

- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_SYSTEM_AVATAR withIsUserInteraction:NO];
        [_headerImageView setContentMode:UIViewContentModeScaleAspectFill];
        CAShapeLayer *shape = [BasisUITool headPortraitRoundProcessing:48];
        [_headerImageView.layer setMask:shape];
    }
    return _headerImageView;
}

#pragma mark - identity
+ (NSString *)cellReuseIdentifierInfo{
    return @"PersonInfoViewTableViewCell";
}

@end
