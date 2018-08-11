//
//  TopNavBarView.m
//  HWTou
//
//  Created by Reyna on 2017/11/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TopNavBarView.h"
#import "PublicHeader.h"

@interface TopNavBarView () {
    UIView   *_backBGView;
    UIButton *_backBtn;
    UILabel  *_label;
    
    int _type;
}
@end

@implementation TopNavBarView

- (instancetype)initWithFrame:(CGRect)frame type:(int)type {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    _backBGView = [[UIView alloc] initWithFrame:self.bounds];
//    _backBGView.backgroundColor = UIColorFromHexA(0x000000, 0.3);
    _backBGView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backBGView];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 20, 44, 44);
    if (_type == 1 || _type == 2) {
        [_backBtn setImage:[UIImage imageNamed:@"navi_back_white"] forState:UIControlStateNormal];
    }
    else {
        [_backBtn setImage:[UIImage imageNamed:@"signin_nav_back"] forState:UIControlStateNormal];
    }
    
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth - 100)/2.0, 20, 100, 44)];
    _label.font = SYSTEM_FONT(18);
    if (_type == 1) {
        _label.text = @"邀请好友";
        _label.textColor = [UIColor whiteColor];
    }
    else if (_type == 2) {
        _label.text = @"我的钱包";
        _label.textColor = [UIColor whiteColor];
    }
    else {
        _label.text = @"排行榜";
        _label.textColor = UIColorFromHex(0x2b2b2b);
    }
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

- (void)setNavBarAlpha:(CGFloat)alpha {
    
    _backBGView.alpha = alpha;
}

- (void)backAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topNavBackBtnAction)]) {
        [self.delegate topNavBackBtnAction];
    }
}

@end
