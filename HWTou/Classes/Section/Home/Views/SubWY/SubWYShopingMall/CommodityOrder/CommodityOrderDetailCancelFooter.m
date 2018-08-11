//
//  CommodityOrderDetailCancelFooter.m
//  HWTou
//
//  Created by robinson on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "CommodityOrderDetailCancelFooter.h"

@implementation CommodityOrderDetailCancelFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCountTimeStr:(NSString *)countTimeStr{
    self.titleLabel.text = countTimeStr;
}

+ (NSString *)cellIdentity{
    return @"CommodityOrderDetailCancelFooter";
}
@end
