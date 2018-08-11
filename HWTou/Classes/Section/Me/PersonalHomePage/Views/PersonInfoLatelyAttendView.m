//
//  PersonInfoLatelyAttendView.m
//  HWTou
//
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonInfoLatelyAttendView.h"
#import "PublicHeader.h"

@interface PersonInfoLatelyAttendView()
@property (nonatomic,strong) UIImageView * imageView;//头像
@property (nonatomic,strong) UILabel * label;//名称
@end

@implementation PersonInfoLatelyAttendView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView{
    [self addSubview:self.imageView];
    [self addSubview:self.label];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView);
        make.top.equalTo(self.imageView.mas_bottom).offset(5);
        make.size.equalTo(CGSizeMake(45, 10));
    }];
}

- (void)setNickName:(NSString *)nickName{
    _nickName = nickName;
    self.label.text = nickName;
}

- (void)setImageName:(NSString *)imageName{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
}

- (UILabel *)label{
    if (!_label) {
        _label = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:9];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_SYSTEM_AVATAR withIsUserInteraction:NO];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        CAShapeLayer *shape = [BasisUITool headPortraitRoundProcessing:40];
        [_imageView.layer setMask:shape];
    }
    return _imageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
