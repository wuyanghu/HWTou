//
//  AudioPlayerHeaderView.m
//  HWTou
//
//  Created by Reyna on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "AudioPlayerHeaderView.h"
#import "PublicHeader.h"
#import "PlayHighInfoViewModel.h"
#import "VoiceReplyView.h"

#define RATIO_HEADERIMG 250/375.0f

@interface AudioPlayerHeaderView ()
{
    UILabel *listLab;
}
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, strong) UILabel *infoLab;

@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) VoiceReplyView *voiceReplyView;
@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, assign) BOOL isHiddenProgressBar; //是否隐藏进度条

@end

@implementation AudioPlayerHeaderView

- (instancetype)initWithFrame:(CGRect)frame progressBarHidden:(BOOL)isHidden {
   
    CGFloat bottomHeight = isHidden ? 80 : 83;
    CGRect f = CGRectMake(frame.origin.x, frame.origin.y, kMainScreenWidth, kMainScreenWidth * RATIO_HEADERIMG + bottomHeight);
    self = [super initWithFrame:f];
    if (self) {
        _isHiddenProgressBar = isHidden;
        [self createView];
    }
    return self;
}

//重要信息
- (void)bindHighInfoView:(HistoryTopModel *)topModel{
    _topModel = topModel;
    _leftView.hidden = NO;
    _rightView.hidden = NO;
    self.infoLab.hidden = YES;
    listLab.text = @"主播";
    if (topModel) {
        self.headerImageView.hidden = NO;
        self.voiceReplyView.hidden = NO;
        
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:topModel.avater]];
        
        self.voiceReplyView.voiceDuration = (int)topModel.duration;
        [self.voiceReplyView registerWithVoiceUrl:topModel.comUrl];
    }else{
        self.headerImageView.hidden = YES;
        self.voiceReplyView.hidden = YES;
    }
    self.bounds = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * RATIO_HEADERIMG+80);
}

- (void)bind:(PlayerDetailViewModel *)viewModel playing:(NSString *)playing flag:(int)flag {
    
    _flag = flag;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:[viewModel.bmgsArr firstObject]]];
    
    if (flag == 3) {//聊吧
        _leftView.hidden = NO;
        _rightView.hidden = NO;
        self.infoLab.hidden = YES;
        
    }else{
        _leftView.hidden = YES;
        _rightView.hidden = YES;
        
        self.bounds = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * RATIO_HEADERIMG);
    }
    
    /*
    if (flag == 1) {
        [self.headerIV sd_setImageWithURL:[NSURL URLWithString:[viewModel.bmgsArr firstObject]]];
        self.infoLab.text = playing;
        
        _leftView.hidden = NO;
        _rightView.hidden = NO;
        
        self.bounds = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * RATIO_HEADERIMG + 80);
        
    }
    else {
        [self.headerIV sd_setImageWithURL:[NSURL URLWithString:[viewModel.bmgsArr firstObject]]];
        _leftView.hidden = YES;
        _rightView.hidden = YES;
        
        self.bounds = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * RATIO_HEADERIMG);
    }
     */
    
}

- (void)createView {
    
    self.backgroundColor = UIColorFromHex(0xf3f4f6);
    
    [self addSubview:self.headerIV];
    
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(10, kMainScreenWidth * RATIO_HEADERIMG + 10, 60, 60)];
    _leftView.backgroundColor = [UIColor whiteColor];
    _leftView.layer.cornerRadius = 5.f;
    _leftView.layer.masksToBounds = YES;
    [self addSubview:_leftView];
    
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [listBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    listBtn.frame = _leftView.bounds;
    [_leftView addSubview:listBtn];
    UIImageView *listIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 20)];
    listIV.image = [UIImage imageNamed:@"-s-lk_list"];
    [listBtn addSubview:listIV];
    listLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 39, 30, 12)];
    listLab.text = @"列表";
    listLab.textColor = UIColorFromHex(0x818281);
    listLab.font = SYSTEM_FONT(12);
    listLab.textAlignment = NSTextAlignmentCenter;
    [listBtn addSubview:listLab];
    
    _rightView = [[UIView alloc] initWithFrame:CGRectMake(85, kMainScreenWidth * RATIO_HEADERIMG + 10, kMainScreenWidth - 90, 60)];
    _rightView.backgroundColor = [UIColor whiteColor];
    _rightView.layer.cornerRadius = 5.f;
    _rightView.layer.masksToBounds = YES;
    [self addSubview:_rightView];
    
    [_rightView addSubview:self.infoLab];
    
    [_rightView addSubview:self.headerImageView];
    [_rightView addSubview:self.voiceReplyView];
}

#pragma mark - Action

- (void)buttonClick:(UIButton *)button{
    if (self.flag == 1) {
        [_headerViewDelegate programClick];
    }else if(self.flag == 3){
        [_headerViewDelegate hignInfoClick];
    }
}

#pragma mark - Get

- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [BasisUITool getImageViewWithImage:@"" withIsUserInteraction:NO];
        _headerImageView.frame = CGRectMake(10, 10, 40, 40);
        [_headerImageView setContentMode:UIViewContentModeScaleAspectFill];
        CAShapeLayer *shape = [BasisUITool headPortraitRoundProcessing:40];
        [_headerImageView.layer setMask:shape];
    }
    return _headerImageView;
}


- (VoiceReplyView *)voiceReplyView{
    if (!_voiceReplyView) {
        _voiceReplyView = [[VoiceReplyView alloc] initWithFrame:CGRectMake(55, 14.5, 158, 30)];
        _voiceReplyView.isClickPlay = YES;
    }
    return _voiceReplyView;
}

- (UIImageView *)headerIV {
    if (!_headerIV) {
        _headerIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * RATIO_HEADERIMG)];
        _headerIV.userInteractionEnabled = YES;
        _headerIV.layer.masksToBounds = YES;
    }
    return _headerIV;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] init];
        _infoLab.font = SYSTEM_FONT(17);
        _infoLab.textColor = UIColorFromHex(0x818281);
        _infoLab.frame = CGRectMake(20, 20, kMainScreenWidth - 125 , 20);
    }
    return _infoLab;
}

@end
