//
//  MeHeaderCollectionReusableView.m
//  HWTou
//
//  Created by robinson on 2017/12/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MeHeaderReusableView.h"
#import "PublicHeader.h"
#import "PersonHomeDM.h"

@implementation MeHeaderReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView{
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.headerImageView];
    [self.bgView addSubview:self.userNameLabel];
    
    _attentBtn = [BasisUITool getBtnWithTarget:self action:@selector(selectedButton:)];
    _attentBtn.tag = 1;
    [_attentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bgView addSubview:_attentBtn];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor blackColor];
    [self.bgView addSubview:lineView];
    
    _fansBtn = [BasisUITool getBtnWithTarget:self action:@selector(selectedButton:)];
    _fansBtn.tag = 2;
    [_fansBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bgView addSubview:_fansBtn];
    
    /* ********** layout UI ********** */
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo((210));
    }];
    
    // 头像居中
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.size.equalTo(CGSizeMake(70, 70));
        make.top.equalTo(self.bgView).offset(74);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.bottom).offset(11.5);
        make.centerX.equalTo(self.headerImageView);
    }];
    
    [self.attentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.userNameLabel.mas_bottom);
        make.right.equalTo(lineView).offset(-30);
        make.height.equalTo(30);
        
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(5);
        make.bottom.equalTo(_attentBtn.mas_bottom).offset(-5);
        make.width.equalTo(0.5);
        make.centerX.equalTo(self.bgView);
    }];
    
    [_fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_attentBtn);
        make.left.equalTo(lineView).offset(30);
        make.height.equalTo(_attentBtn);
        
    }];
    
    /* ********** layout UI End ********** */
    
}

- (void)setPersonHomeModel:(PersonHomeDM *)personHomeModel{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:personHomeModel.headUrl]];
    self.userNameLabel.text = personHomeModel.nickname;
    
    [self.attentBtn setTitle:[NSString stringWithFormat:@"关注%ld",personHomeModel.focusNum] forState:UIControlStateNormal];
    [self.fansBtn setTitle:[NSString stringWithFormat:@"粉丝%ld",personHomeModel.fansNum] forState:UIControlStateNormal];
}

- (void)selectedButton:(UIButton *)button{
    [_m_Delegate buttonSelected:button];
}

- (void)tapGestureFloor:(UITapGestureRecognizer *)tapGesture{
    [_m_Delegate tapGestureFloor:tapGesture];
}

#pragma mark - getter

- (UILabel *)userNameLabel{
    if (!_userNameLabel) {
        // 用户昵称
        UILabel *userNameLbl = [BasisUITool getBoldLabelWithTextColor:[UIColor blackColor]
                                                                 size:CLIENT_COMMON_FONT_CONTENT_SIZE];
        [userNameLbl setTextAlignment:NSTextAlignmentCenter];
        _userNameLabel = userNameLbl;
    }
    return _userNameLabel;
}

- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        // 用户头像
        UIImageView *avatarImgView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_SYSTEM_AVATAR
                                                  withIsUserInteraction:YES];
        [avatarImgView setContentMode:UIViewContentModeScaleAspectFill];
        CAShapeLayer *shape = [BasisUITool headPortraitRoundProcessing:70];
        [avatarImgView.layer setMask:shape];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(tapGestureFloor:)];
        
        [avatarImgView addGestureRecognizer:tapGesture];
        
        _headerImageView = avatarImgView;
    }
    return _headerImageView;
}

- (UIImageView *)bgView{
    if (!_bgView) {
        // 头像背景
        _bgView = [BasisUITool getImageViewWithImage:@"bg_img_1" withIsUserInteraction:NO];
        [_bgView setContentMode:UIViewContentModeScaleToFill];
        [_bgView setUserInteractionEnabled:YES];
    }
    return _bgView;
}

#pragma mark - static method
+ (NSString *)cellIdentity{
    return @"MeHeaderReusableView";
}
@end

@implementation MeHeaderBgView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * bgView = [[UIView alloc] init];
        bgView.backgroundColor = UIColorFromHex(0XEEEEEE);
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

+(NSString *)cellIdentity{
    return @"MeHeaderBgView";
}

@end
