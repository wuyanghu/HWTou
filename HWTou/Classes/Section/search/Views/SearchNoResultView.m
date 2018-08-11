//
//  SearchNoResultView.m
//  HWTou
//
//  Created by robinson on 2017/12/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SearchNoResultView.h"
#import "PublicHeader.h"

@implementation SearchNoResultView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromHex(0xF3F4F6);
        
        UIImageView * imageView = [BasisUITool getImageViewWithImage:@"kb_icon_ss" withIsUserInteraction:NO];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(150, 145));
            make.top.equalTo(self).offset(105);
            make.centerX.equalTo(self);
        }];
        
        UILabel * label = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2b2b2b) size:14];
        label.text = @"没有找到相关结果";
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(imageView.mas_bottom).offset(30);
            make.height.equalTo(14);
        }];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
