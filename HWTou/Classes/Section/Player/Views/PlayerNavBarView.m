//
//  PlayerNavBarView.m
//  HWTou
//
//  Created by Reyna on 2017/11/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PlayerNavBarView.h"
#import "PublicHeader.h"

@interface PlayerNavBarView () {
    UIView   *_backBGView;
    UIButton *_backBtn;
    UIButton *_shareBtn;
}
@end
@implementation PlayerNavBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    _backBGView = [[UIView alloc] init];
    _backBGView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:0];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"ts_icon_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"ts_icon_share"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
   
    [self addSubview:_backBtn];
    [self addSubview:_shareBtn];
    
    [_backBGView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(26);
        make.left.equalTo(self.left).offset(10);
    }];
    
    [_shareBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(26);
        make.right.equalTo(self.right).offset(-10);
    }];
}

- (void)setNavBarAlpha:(CGFloat)alpha {
    
    _backBGView.alpha = alpha;
}

- (void)backAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerNavBackBtnAction)]) {
        [self.delegate playerNavBackBtnAction];
    }
}

- (void)shareAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerNavShareBtnAction)]) {
        [self.delegate playerNavShareBtnAction];
    }
}

@end
