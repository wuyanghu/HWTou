//
//  MMShareView.m
//
//  Created by pengpeng on 16/5/13.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import "UIButton+ImageTitleSpacing.h"
#import "SocialThirdController.h"
#import "UIImage+Extension.h"
#import "SocialShareView.h"
#import <Masonry/Masonry.h>
#import "AppConfigMacro.h"

@interface SocialShareView ()
{
    UILabel         *_labTitle;
    UIButton        *_btnCancel;
    UIView          *_viewLine;
    UIView          *_viewShareBtn; // 所有分享按钮
}

@property (nonatomic, strong) NSArray *shareList;
@property (nonatomic, strong) NSMutableArray *shareBtn;

@end

@implementation SocialShareView

- (void)setupShareData
{
    SocialShareDM *wxFriend = [SocialShareDM new];
    wxFriend.shareType = SocialShareWXFriend;
    wxFriend.title = @"微信";
    wxFriend.imgNor = @"share_wechat_friend";
    
    SocialShareDM *wxTimeline = [SocialShareDM new];
    wxTimeline.shareType = SocialShareWXTimeline;
    wxTimeline.title = @"朋友圈";
    wxTimeline.imgNor = @"share_wechat_timeline";
    
    SocialShareDM *qqFriend = [SocialShareDM new];
    qqFriend.shareType = SocialShareQQFriend;
    qqFriend.title = @"QQ好友";
    qqFriend.imgNor = @"share_qq_friend";
    
    SocialShareDM *qqZone = [SocialShareDM new];
    qqZone.shareType = SocialShareQQZone;
    qqZone.title = @"QQ空间";
    qqZone.imgNor = @"share_qq_zone";
    
    SocialShareDM *weibo = [SocialShareDM new];
    weibo.shareType = SocialShareWeibo;
    weibo.title = @"微博";
    weibo.imgNor = @"share_weibo";
    
    if ([SocialThirdController isWeixinInstalled] == NO) {
        wxFriend.disable = YES;
        wxTimeline.disable = YES;
    }
    
    if ([SocialThirdController isQQInstalled] == NO) {
        qqFriend.disable = YES;
        qqZone.disable = YES;
    }
    
    if ([SocialThirdController isWeiboInstalled] == NO) {
        weibo.disable = YES;
    }
    
    self.shareList = @[wxFriend, wxTimeline, qqFriend, qqZone, weibo];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createUI];
        [self setupShareData];
        [self setupShareButton];
    }
    
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
//    [self addGestureRecognizer:tapGesture];
    
    _labTitle = [[UILabel alloc] init];
    _labTitle.text = @"分享至:";
    _labTitle.font = [UIFont systemFontOfSize:14.0f];
    _labTitle.textColor = [UIColor blackColor];
    
    _viewShareBtn = [[UIView alloc] init];
    _viewLine = [[UIView alloc] init];
    _viewLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    _btnCancel = [[UIButton alloc] init];
    [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [_btnCancel setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [_btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnCancel setTitle:@"取 消" forState:UIControlStateNormal];
//    [_btnCancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_labTitle];
    [self addSubview:_btnCancel];
    [self addSubview:_viewLine];
    [self addSubview:_viewShareBtn];
    
    [_labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.leading.equalTo(@12);
        make.height.equalTo(@15);
    }];
    
    [_viewShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(_labTitle.mas_bottom);
        make.bottom.equalTo(_viewLine.mas_top);
    }];
    
    [_viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.bottom.equalTo(_btnCancel.mas_top);
        make.height.mas_equalTo(@0.5);
    }];
    
    [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self);
        make.height.mas_equalTo(@44);
    }];
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIButton *button in self.shareBtn) {
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:8];
    }
}

- (void)setupShareButton
{
    NSUInteger count = self.shareList.count;
    CGFloat percentW = (CGFloat)1/count;
    
    UIView *lastView = nil;
    for (NSUInteger index = 0; index < count; index++)
    {
        SocialShareDM *share = self.shareList[index];
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = share.shareType;
        [button setTitle:share.title forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:share.imgNor] forState:UIControlStateNormal];
        if (share.imgHlt.length > 0) {
            [button setImage:[UIImage imageNamed:share.imgHlt] forState:UIControlStateHighlighted];
        }
        if (share.disable) {
            button.enabled = NO;
        }
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateDisabled];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [button addTarget:self action:@selector(actionShareEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [_viewShareBtn addSubview:button];
        [self.shareBtn addObject:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(_viewShareBtn);
            make.width.equalTo(_viewShareBtn).multipliedBy(percentW);
            make.leading.equalTo(!lastView ? @0 : lastView.mas_trailing);
        }];
        lastView = button;
    }
}

- (NSMutableArray *)shareBtn
{
    if (_shareBtn == nil) {
        _shareBtn = [NSMutableArray arrayWithCapacity:self.shareList.count];
    }
    return _shareBtn;
}

- (void)actionShareEvent:(UIButton *)button
{
    SocialShareType operate = button.tag;
    !self.shareOperate ?: self.shareOperate(operate);
}
@end
