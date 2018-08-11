//
//  TopicFooterCollectionReusableView.m
//  HWTou
//
//  Created by robinson on 2017/12/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TopicFooterCollectionReusableView.h"
#import "PublicHeader.h"

@implementation TopicFooterCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * bgView = [[UIView alloc] init];
        bgView.backgroundColor = UIColorFromHex(0xF3F4F6);
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end
