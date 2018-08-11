//
//  OrderRefundView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderRefundView.h"
#import "PublicHeader.h"

@interface OrderRefundView ()
{
    
}

@end

@implementation OrderRefundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIView *vMoneyBG = [self createBGView];
    UIView *vExplainBG = [self createBGView];
    
#if 0
    UILabel *labStar1 = [self createLabel:@"*" fontSize:15.0f];
    UILabel *labStar2 = [self createLabel:@"*" fontSize:15.0f];
    
    UILabel *labMoney = [self createLabel:@"退款金额" fontSize:14];
    UILabel *labExplain = [self createLabel:@"退款说明" fontSize:14];
#endif
    
    UITextField *tfExplain = [[UITextField alloc] init];
    tfExplain.textColor = UIColorFromHex(0x333333);
    tfExplain.placeholder = @"最多200字";
    tfExplain.font = FontPFRegular(12.0f);
    
    [vMoneyBG makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [vExplainBG makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}

- (UIView *)createBGView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromHex(0xebebeb);
    [view setRoundWithCorner:4.0f];
    return view;
}

- (UILabel *)createLabel:(NSString *)text fontSize:(CGFloat)size
{
    UILabel *label = [[UILabel alloc] init];
    label.font = FontPFRegular(size);
    label.textColor = UIColorFromHex(0xb4292d);
    label.text = text;
    
    return label;
}

@end
