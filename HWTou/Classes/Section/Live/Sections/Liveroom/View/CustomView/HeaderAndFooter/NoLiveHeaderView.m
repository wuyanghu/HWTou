//
//  NoLiveHeaderView.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "NoLiveHeaderView.h"
#import "UIView+NTES.h"

@interface NoLiveHeaderView()
@property (nonatomic,strong) UILabel * onlineLabel;//在线人数
@end

@implementation NoLiveHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.onlineLabel];
    }
    return self;
}

- (UILabel *)onlineLabel{
    if (!_onlineLabel) {
        _onlineLabel = [[UILabel alloc] init];
        _onlineLabel.backgroundColor = [UIColor clearColor];
        _onlineLabel.frame = CGRectMake(self.ntesWidth-122-75, 7, 122, 12);
        _onlineLabel.text = @"在线:9999";
        _onlineLabel.font = [UIFont systemFontOfSize:12];
        _onlineLabel.textColor = UIColorFromRGB(0xFF8E8F91);
        _onlineLabel.textAlignment = NSTextAlignmentRight;
        
        UIButton * noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        noticeBtn.frame = CGRectMake(self.ntesWidth-65, 0, 50, 25);
        [noticeBtn setTitle:@"公告" forState:UIControlStateNormal];
        [noticeBtn.layer setMasksToBounds:YES];
        [noticeBtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
        //边框宽度
        [noticeBtn.layer setBorderWidth:1.0];
        noticeBtn.layer.borderColor = UIColorFromRGB(0xFFD2D2D2).CGColor;
        [noticeBtn addTarget:self action:@selector(noticeAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:noticeBtn];
    }
    return _onlineLabel;
}

- (void)setChatInfoModel:(GetChatInfoModel *)chatInfoModel{
    _chatInfoModel = chatInfoModel;
    self.onlineLabel.text = [NSString stringWithFormat:@"在线:%ld 累计:%ld",chatInfoModel.online,chatInfoModel.lookNum];
}

- (void)noticeAction{
    NSLog(@"公告");
    [_noLiveDelegate noLiveHeaderViewAction:LiveHeaderViewTypeNotice];
}

@end
