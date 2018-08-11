//
//  BaseNoDataView.m
//  HWTou
//
//  Created by Reyna on 2017/11/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseNoDataView.h"
#import "PublicHeader.h"

@implementation BaseNoDataView

- (instancetype)initWithFrame:(CGRect)frame type:(NoDataViewType)type {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 200, 200)];
    if (self) {
        [self createUIWithType:type];
    }
    return self;
}

- (void)createUIWithType:(NoDataViewType)type {
    self.userInteractionEnabled = NO;
    
    [self addSubview:self.imageView];
    [self addSubview:self.msgLabel];
    
    switch (type) {
        case NoDataViewTypeContent:
        {
            self.imageView.image = [UIImage imageNamed:@"kb_icon_wn"];
            self.msgLabel.text = @"暂无内容";
        }
            break;
        case NoDataViewTypeSearch:
        {
            self.imageView.image = [UIImage imageNamed:@"kb_icon_ss"];
            self.msgLabel.text = @"没有找到相关结果";
        }
            break;
        case NoDataViewTypeMessage:
        {
            self.imageView.image = [UIImage imageNamed:@"kb_icon_xx"];
            self.msgLabel.text = @"暂无消息";
        }
            break;
        case NoDataViewTypeCommunity:
        {
            self.imageView.image = [UIImage imageNamed:@"kb_icon_hd"];
            self.msgLabel.text = @"哎～什么互动都没有";
        }
            break;
        case NoDataViewTypeNetworking:
        {
            self.imageView.image = [UIImage imageNamed:@"kb_icon_nowifi"];
            self.msgLabel.text = @"无网络链接，请重新连接";
        }
            break;
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 5, 150, 145)];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 185, 150, 15)];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = SYSTEM_FONT(14);
        _msgLabel.textColor = UIColorFromHex(0x2b2b2b);
    }
    return _msgLabel;
}

@end
