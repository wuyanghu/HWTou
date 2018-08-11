//
//  CustomButton.m
//  HWTou
//
//  Created by robinson on 2017/11/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CustomButton.h"
#import "PublicHeader.h"

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//绘制换一批btn
- (void)drawExchageBtn{
    UILabel * titleLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x595656) size:12];
    titleLabel.text = @"换一批";
    [self addSubview:titleLabel];
    
    UIImageView * imageView = [BasisUITool getImageViewWithImage:@"content_icon_batch_change" withIsUserInteraction:NO];
    [self addSubview:imageView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(36, 12));
        make.center.equalTo(self);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(12, 14));
        make.centerY.equalTo(titleLabel);
        make.left.equalTo(titleLabel.mas_right).offset(8);
    }];
}
//更多
- (void)drawMoreBtn{
    UILabel * titleLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8e8f94) size:14];
    titleLabel.text = @"更多";
    [self addSubview:titleLabel];
    
    UIImageView * imageView = [BasisUITool getImageViewWithImage:@"btn_next" withIsUserInteraction:NO];
    [self addSubview:imageView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(28, 14));
        make.center.equalTo(self);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(8, 14));
        make.centerY.equalTo(titleLabel);
        make.left.equalTo(titleLabel.mas_right).offset(5);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
