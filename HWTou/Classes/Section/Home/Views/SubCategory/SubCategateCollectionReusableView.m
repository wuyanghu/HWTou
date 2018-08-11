//
//  SubCategateCollectionReusableView.m
//  HWTou
//
//  Created by robinson on 2018/1/5.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SubCategateCollectionReusableView.h"
#import "PublicHeader.h"

@implementation SubCategateCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:18];
        _titleLabel.frame = CGRectMake(11, 15, 200, 18);
        [self addSubview:_titleLabel];
    }
    return self;
}

+ (NSString *)cellIdentity{
    return @"SubCategateCollectionReusableView";
}

@end
