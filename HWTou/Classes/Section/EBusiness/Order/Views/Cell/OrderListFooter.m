//
//  OrderListFooter.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PaymentWayViewController.h"
#import "OrderListFooter.h"
#import "OrderDetailDM.h"
#import "PublicHeader.h"

@interface OrderListFooter ()
{
    UIButton    *_btnLeft;
    UIButton    *_btnRight;
}
@end

@implementation OrderListFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _btnLeft = [[UIButton alloc] init];
    [_btnLeft setRoundWithCorner:2.0f];
    _btnLeft.titleLabel.font = FontPFRegular(13);
    [_btnLeft setTitleColor:UIColorFromHex(0xb4292d) forState:UIControlStateNormal];
    [_btnLeft setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _btnLeft.layer.borderColor = UIColorFromHex(0xb4292d).CGColor;
    _btnLeft.layer.borderWidth = Single_Line_Width;
    [_btnLeft addTarget:self action:@selector(actionButtonLeft:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnRight = [[UIButton alloc] init];
    [_btnRight setRoundWithCorner:2.0f];
    _btnRight.titleLabel.font = FontPFRegular(13);
    [_btnRight setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xb4292d)] forState:UIControlStateNormal];
    [_btnRight addTarget:self action:@selector(actionButtonRight:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_btnLeft];
    [self addSubview:_btnRight];
    
    [_btnLeft makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_btnRight.leading).offset(-15);
        make.size.equalTo(CGSizeMake(75, 30));
        make.centerY.equalTo(self);
    }];
    
    [_btnRight makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.equalTo(_btnLeft);
        make.trailing.equalTo(self).offset(-15);
    }];
}

- (void)setDmOrder:(OrderDetailDM *)dmOrder
{
    _dmOrder = dmOrder;
    NSString *leftTitle = nil;
    NSString *rightTitle = nil;
    switch (dmOrder.status) {
        case OrderStatusWaitPay:
        case OrderStatusPayProcess:
            leftTitle = @"取消订单";
            rightTitle = @"付款";
            break;
        case OrderStatusReapGoods:
            leftTitle = @"查看物流";
            rightTitle = @"确认收货";
            break;
        case OrderStatusWaitComment:
            leftTitle = @"查看物流";
            rightTitle = @"评价";
            break;
        default:
            break;
    }
    [_btnLeft setTitle:leftTitle forState:UIControlStateNormal];
    [_btnRight setTitle:rightTitle forState:UIControlStateNormal];
}

- (void)actionButtonLeft:(UIButton *)button
{
    switch (self.dmOrder.status) {
        case OrderStatusWaitPay: // 取消订单
        case OrderStatusPayProcess:
            [self actionOrderEvent:OrderEventCancel];
            break;
        case OrderStatusReapGoods: // 物流跟踪
        case OrderStatusWaitComment:
            [self actionOrderEvent:OrderEventMail];
            break;
        default:
            break;
    }
    
}

- (void)actionButtonRight:(UIButton *)button
{
    switch (self.dmOrder.status) {
        case OrderStatusWaitPay: // 付款
        case OrderStatusPayProcess:
            [self handlePayment];
            break;
        case OrderStatusReapGoods:
            [self actionOrderEvent:OrderEventConfirm];
            break;
        case OrderStatusWaitComment:
            [self actionOrderEvent:OrderEventComment];
            break;
        default:
            break;
    }
}

- (void)actionOrderEvent:(OrderEvent)event
{
    if ([self.delegate respondsToSelector:@selector(onOrderEvent:order:)]) {
        [self.delegate onOrderEvent:event order:self.dmOrder];
    }
}
- (void)handlePayment
{
    PaymentWayViewController *payVC = [[PaymentWayViewController alloc] init];
    payVC.dmOrder = self.dmOrder;
    [[UIApplication topViewController].navigationController pushViewController:payVC animated:YES];
}
@end
