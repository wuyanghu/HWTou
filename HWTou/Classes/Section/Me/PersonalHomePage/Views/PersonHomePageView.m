//
//  PersonHomePageView.m
//  HWTou
//
//  Created by robinson on 2017/11/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonHomePageView.h"
#import "ComCarouselView.h"
#import "PublicHeader.h"
#import "BasisUITool.h"
#import "VTMagic.h"
#import "CalabashColViewController.h"
#import "PersonInfoViewController.h"

#define not_concern @"not_concern"//关注
#define btn_notconcern @"btn_notconcern"//编辑资料

@interface PersonHomePageView()<ComCarouselViewDelegate>
@property (nonatomic,strong) ComCarouselImageView * vCarouselImg; // 图片轮播

@property (nonatomic,strong) UIImageView * headerImageView;//头像
@property (nonatomic,strong) UILabel * nicknameLabel;//昵称
@property (nonatomic,strong) UIButton * fansBtn;//粉丝
@property (nonatomic,strong) UIButton * attentionBtn;//关注
@property (nonatomic,strong) UIButton * editBtn;//关注(编辑资料)

@end

@implementation PersonHomePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self drawMainView];
    }
    return self;
}

- (void)setPersonHomeModel:(PersonHomeDM *)personHomeModel{
    _personHomeModel = personHomeModel;
    
    self.vCarouselImg.imageURLStringsGroup = [personHomeModel getBgBmgs];
    
    [self isAttend:personHomeModel.isFocus];

    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:personHomeModel.headUrl]];//设置头像
    self.nicknameLabel.text = personHomeModel.nickname;
    [self.fansBtn setTitle:[NSString stringWithFormat:@"粉丝 %ld",personHomeModel.fansNum] forState:UIControlStateNormal];
    [self.attentionBtn setTitle:[NSString stringWithFormat:@"关注 %ld",personHomeModel.focusNum] forState:UIControlStateNormal];
    [self changeBtnColor:self.fansBtn];
    [self changeBtnColor:self.attentionBtn];
}

- (void)changeBtnColor:(UIButton *)button{
    if (button.currentTitle.length>2) {
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:button.currentTitle];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:UIColorFromHex(0x8E8F91)
                              range:NSMakeRange(0, 2)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:UIColorFromHex(0xFF6767)
                              range:NSMakeRange(2, button.currentTitle.length-2)];
        [button setAttributedTitle:AttributedStr forState:UIControlStateNormal];
    }
}


- (void)drawMainView{
    [self addSubview:self.vCarouselImg];
    [self.vCarouselImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(226);
    }];
    
    [self addSubview:self.headerImageView];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.fansBtn];
    [self addSubview:self.attentionBtn];
    [self addSubview:self.editBtn];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(48, 48));
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.vCarouselImg.mas_bottom).offset(10);
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(14);
        make.width.greaterThanOrEqualTo(100);
        make.left.equalTo(self.headerImageView.mas_right).offset(7);
        make.top.equalTo(self.headerImageView).offset(7);
    }];
    
    [self.fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.nicknameLabel);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(10);
        make.height.equalTo(12);
    }];
    
    [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(self.fansBtn);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(5);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(80, 30));
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.nicknameLabel).offset(10);
    }];
    
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColorFromHex(0xF3F4F6);
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(10);
        make.height.equalTo(10);
    }];
//    
//    UIView * segementBgView = [[UIView alloc] init];
//    segementBgView.backgroundColor = UIColorFromHex(0xF3F4F6);
//    segementBgView.layer.cornerRadius = 5;
//    segementBgView.layer.masksToBounds = YES;
//    [self addSubview:segementBgView];
//    
//    [segementBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
//        make.width.equalTo(kMainScreenWidth-20);
//        make.top.equalTo(bgView.mas_bottom).offset(10);
//        make.height.equalTo(40);
//    }];
//    
//    
//    [self addSubview:self.segment];
//    
//    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(segementBgView).offset(5);
//        make.width.equalTo(kMainScreenWidth-30);
//        make.top.equalTo(segementBgView).offset(5);
//        make.height.equalTo(30);
//        
//    }];
}

- (void)segmentChange:(UISegmentedControl *)segmentedControl{
    [_homePageDelegate segmentChange:segmentedControl];
}

#pragma mark - click
- (void)buttonClick:(UIButton *)button{
    if (button.tag == 0) {//编辑资料
        [_homePageDelegate buttonSelectedEdit:button];
    }else if (button.tag == 1){//关注列表
        [_homePageDelegate buttonClick:button];
    }else if (button.tag == 2){//粉丝列表
        [_homePageDelegate buttonClick:button];
    }
    
}

- (void)isAttend:(NSInteger)isFocus{
    if (_buttonType == dynamicButtonType) {
        if (isFocus == 0) {
            [self.editBtn setImage:[UIImage imageNamed:@"not_concern"] forState:UIControlStateNormal];//关注
        }else{
            [self.editBtn setImage:[UIImage imageNamed:@"gr_concern"] forState:UIControlStateNormal];//已关注
        }
    }
}

#pragma mark - ComRollViewDelegate
- (void)carouselView:(ComCarouselView *)view didSelectItemAtIndex:(NSInteger)index
{
    
}

#pragma mark - Set

- (void)setButtonType:(PersonHomePageButtonType)buttonType{
    _buttonType = buttonType;
    if (_buttonType == editDataButtonType) {
        [self.editBtn setImage:[UIImage imageNamed:@"btn_bj"] forState:UIControlStateNormal];
    }else if (_buttonType == dynamicButtonType){
        [self.editBtn setImage:[UIImage imageNamed:@"not_concern"] forState:UIControlStateNormal];
    }
}

- (void)setIsHost:(BOOL)isHost {
    if (_isHost != isHost) {
        _isHost = isHost;
        
        if (_isHost) {
            [self.segment insertSegmentWithTitle:@"话题" atIndex:2 animated:YES];
            
            [self.segment setWidth:(kMainScreenWidth - 30)/3.0 forSegmentAtIndex:0];
            [self.segment setWidth:(kMainScreenWidth - 30)/3.0 forSegmentAtIndex:1];
            [self.segment setWidth:(kMainScreenWidth - 30)/3.0 forSegmentAtIndex:2];
        }
    }
}

#pragma mark - getter

- (UISegmentedControl *)segment{
    if (!_segment) {
        
        NSArray *array = [NSArray arrayWithObjects:@"资料",@"动态", nil];
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
        segment.backgroundColor = UIColorFromHex(0xF3F4F6);
        //根据内容定分段宽度
        segment.apportionsSegmentWidthsByContent = YES;
        segment.selectedSegmentIndex = 1;
        segment.tintColor = UIColorFromHex(0xffffff);
        segment.layer.borderWidth = 1;
        segment.layer.borderColor = [UIColorFromHex(0xF3F4F6) CGColor];
        segment.layer.cornerRadius = 5;
        segment.layer.masksToBounds = YES;
        [segment setWidth:(kMainScreenWidth - 30)/2.0 forSegmentAtIndex:0];
        [segment setWidth:(kMainScreenWidth - 30)/2.0 forSegmentAtIndex:1];
        // 设置选中的文字颜色
        [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0x646665)} forState:UIControlStateNormal];
        [segment setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0x2b2b2b)} forState:UIControlStateSelected];
        
        [segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
        
        _segment = segment;
    }
    return _segment;
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

- (UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:14];
    }
    return _nicknameLabel;
}

- (UIButton *)fansBtn{
    if (!_fansBtn) {
        _fansBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonClick:)];
        _fansBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_fansBtn.titleLabel setFont:FontPFRegular(12)];
        [_fansBtn setTitleColor:UIColorFromHex(0x8E8F91) forState:UIControlStateNormal];
        _fansBtn.tag = 2;
    }
    return _fansBtn;
}

- (UIButton *)attentionBtn{
    if (!_attentionBtn) {
        _attentionBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonClick:)];
        _attentionBtn.tag = 1;
        _attentionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_attentionBtn.titleLabel setFont:FontPFRegular(12)];
        [_attentionBtn setTitleColor:UIColorFromHex(0x8E8F91) forState:UIControlStateNormal];
    }
    return _attentionBtn;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonClick:)];
        _editBtn.tag = 0;
        [_editBtn setImage:[UIImage imageNamed:@"btn_bj"] forState:UIControlStateNormal];
    }
    return _editBtn;
}

- (ComCarouselImageView *)vCarouselImg{
    if (!_vCarouselImg) {
        _vCarouselImg = [[ComCarouselImageView alloc] init];
        _vCarouselImg.delegate = self;
        [_vCarouselImg setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _vCarouselImg;
}

@end
