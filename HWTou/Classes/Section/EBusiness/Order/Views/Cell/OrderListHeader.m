//
//  OrderListHeader.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderListHeader.h"
#import "OrderDetailDM.h"
#import "PublicHeader.h"

@interface OrderListHeader ()
{
    UILabel     *_labOrderNo;
    UILabel     *_labStatus;
}
@end

@implementation OrderListHeader

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
    UIView *vBackgroup = [[UIView alloc] init];
    vBackgroup.backgroundColor = [UIColor whiteColor];
    
    _labOrderNo = [[UILabel alloc] init];
    _labOrderNo.textColor = UIColorFromHex(0x7f7f7f);
    _labOrderNo.font = FontPFRegular(12.0f);
    
    _labStatus = [[UILabel alloc] init];
    _labStatus.textColor = UIColorFromHex(0xb4292d);
    _labStatus.font = FontPFRegular(12.0f);
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
    [self addSubview:vBackgroup];
    [vBackgroup addSubview:vLine];
    [vBackgroup addSubview:_labOrderNo];
    [vBackgroup addSubview:_labStatus];
    
    [vBackgroup makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.leading.trailing.bottom.equalTo(self);
    }];
    
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.equalTo(vBackgroup);
        make.leading.equalTo(_labOrderNo);
        make.height.equalTo(Single_Line_Width);
    }];
    
    [_labOrderNo makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vBackgroup);
        make.leading.equalTo(vBackgroup).offset(15);
    }];
    
    [_labStatus makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vBackgroup);
        make.trailing.equalTo(vBackgroup).offset(-15);
    }];
}

- (void)setDmOrder:(OrderDetailDM *)dmOrder
{
    NSString *status = nil;
    switch (dmOrder.status) {
        case OrderStatusCancel:
            status = @"已取消";
            break;
        case OrderStatusWaitPay:
        case OrderStatusPayProcess:
            status = @"未付款";
            break;
        case OrderStatusSendGoods:
            status = @"卖家未发货";
            break;
        case OrderStatusReapGoods:
            status = @"卖家已发货";
            break;
        case OrderStatusWaitComment:
            status = @"交易成功";
            break;
        case OrderStatusCompleted:
            status = @"已完成";
            break;
        case OrderStatusReturnProce:
            status = @"退款中";
            break;
        case OrderStatusReturnComp:
            status = @"退款成功";
            break;
        default:
            break;
    }
    _labOrderNo.text = [NSString stringWithFormat:@"订单编号: %@", dmOrder.order_no];
    _labStatus.text =  status;
}

@end
