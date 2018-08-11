//
//  OrderDetailView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PaymentWayViewController.h"
#import "ProductEnjoyCell.h"
#import "OrderAddressView.h"
#import "OrderDetailView.h"
#import "AddressGoodsDM.h"
#import "OrderDetailDM.h"
#import "PublicHeader.h"
#import "CommonTable.h"

@interface OrderDetailPayView : UIView
{
    UILabel     *_labMoney;
    UIButton    *_btnPay;
}

@property (nonatomic, strong) OrderDetailDM *dmOrder;

@end

@implementation OrderDetailPayView

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
    _labMoney = [[UILabel alloc] init];
    _labMoney.font = FontPFRegular(13);
    _labMoney.textColor = UIColorFromHex(0xb4292d);
    
    _btnPay = [[UIButton alloc] init];
    [_btnPay setRoundWithCorner:2.0f];
    _btnPay.titleLabel.font = FontPFRegular(12);
    [_btnPay setTitle:@"去付款" forState:UIControlStateNormal];
    [_btnPay setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xb4292d)] forState:UIControlStateNormal];
    [_btnPay addTarget:self action:@selector(actionPayment) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_labMoney];
    [self addSubview:_btnPay];
    
    [_labMoney makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15.0f);
        make.centerY.equalTo(self);
    }];
    
    [_btnPay makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15.0f);
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(80, 30));
    }];
}

- (void)actionPayment
{
    PaymentWayViewController *payVC = [[PaymentWayViewController alloc] init];
    payVC.dmOrder = self.dmOrder;
    [self.viewController.navigationController pushViewController:payVC animated:YES];
}

- (void)setDmOrder:(OrderDetailDM *)dmOrder
{
    _dmOrder = dmOrder;
    _labMoney.text = [NSString stringWithFormat:@"待付款: ¥%.2f", self.dmOrder.price_total];
}
@end

@interface OrderDetailView () <ProductCellDelegate>

@property (nonatomic, strong) CommonTableView *tableView;

@end

@implementation OrderDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self setupGroups];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.tableView = [[CommonTableView alloc] init];
    
    [self addSubview:self.tableView];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (TableCellItem *)cellItemBlack
{
    TableCellItem *blank = [TableCellItem tableItemWithTitle:nil];
    blank.isHideSeparator = YES;
    blank.isSelectionState = NO;
    blank.textCenter = nil;
    blank.cellHeight = 13.0f;
    return blank;
}

// 初始化模型数据
- (void)setupGroups
{
    NSDictionary *dictAttribute = @{NSForegroundColorAttributeName : UIColorFromHex(0x7f7f7f),
                                    NSFontAttributeName : FontPFRegular(14.0f)};
    
    TableCellGroup *group1 = [[TableCellGroup alloc] init];
    
    TableCellItem *blank = [self cellItemBlack];
    
    TableCellItem *orderTime = [TableCellItem tableItemWithTitle:nil];
    orderTime.cellHeight = 22.0f;
    orderTime.isHideSeparator = YES;
    orderTime.isSelectionState = NO;
    orderTime.textCenter = self.dmOrder.create_time;
    orderTime.textCenterColor = UIColorFromHex(0x333333);
    orderTime.titleAttributed = [[NSAttributedString alloc] initWithString:@"下单时间:" attributes:dictAttribute];
    
    TableCellItem *orderNo = [TableCellItem tableItemWithTitle:nil];
    orderNo.cellHeight = 22.0f;
    orderNo.isHideSeparator = YES;
    orderNo.isSelectionState = NO;
    orderNo.textCenter = self.dmOrder.order_no;
    orderNo.textCenterColor = UIColorFromHex(0x333333);
    orderNo.titleAttributed = [[NSAttributedString alloc] initWithString:@"订单编号:" attributes:dictAttribute];
    
    group1.cellItems = @[blank, orderTime, orderNo, blank];
    
    NSMutableArray *products = [NSMutableArray array];
    for (int index = 0; index < self.dmOrder.itemList.count; index++) {
        TableCellCustomItem *product = [TableCellCustomItem tableItemWithTitle:nil];
        product.cellHeight = 96.0f;
        product.textCoordX = CGFLOAT_MIN;
        product.isHideSeparator = YES;
        ProductEnjoyCell *cell = nil;
        switch (self.dmOrder.status) {
#if 0
            case OrderStatusSendGoods:
            case OrderStatusReapGoods:
            case OrderStatusWaitComment:
            case OrderStatusCompleted:
                {
                    ProductRefundCell *refundCell = [[ProductRefundCell alloc] init];
                    refundCell.delegate = self;
                    cell = refundCell;
                }
                break;
#endif
            default:
                cell = [[ProductEnjoyCell alloc] init];
                break;
        }
        [cell setOrderProduct:self.dmOrder.itemList[index]];
        
        product.viewCustom = cell;
        [products addObject:product];
    }
    
    TableCellGroup *group2 = [[TableCellGroup alloc] init];
    group2.headerHeight = 10.0f;
    group2.cellItems = products;
    
    TableCellGroup *group3 = [[TableCellGroup alloc] init];
    group3.headerHeight = 10.0f;
    
    TableCellItem *serviceTel = [TableCellItem tableItemWithTitle:nil];
    serviceTel.cellHeight = 22.0f;
    serviceTel.isHideSeparator = YES;
    serviceTel.isSelectionState = NO;
    serviceTel.textCenter = @"0571-87689328";
    serviceTel.textCenterColor = UIColorFromHex(0x333333);
    serviceTel.titleAttributed = [[NSAttributedString alloc] initWithString:@"客服热线:" attributes:dictAttribute];
    
    TableCellItem *serviceTime = [TableCellItem tableItemWithTitle:nil];
    serviceTime.cellHeight = 22.0f;
    serviceTime.isHideSeparator = YES;
    serviceTime.isSelectionState = NO;
    serviceTime.textCenter = @"工作日 9:00-17:30";
    serviceTime.textCenterColor = UIColorFromHex(0x333333);
    serviceTime.titleAttributed = [[NSAttributedString alloc] initWithString:@"服务时间:" attributes:dictAttribute];
    
    group3.cellItems = @[blank, serviceTel, serviceTime, blank];
    
    TableCellGroup *group4 = [self setupGroupDataLast];
    
    [self.tableView.tableGroups addObjectsFromArray:@[group1, group2, group3, group4]];
}

- (TableCellGroup *)setupGroupDataLast
{
    NSDictionary *dictAttribute = @{NSForegroundColorAttributeName : UIColorFromHex(0x7f7f7f),
                                    NSFontAttributeName : FontPFRegular(14.0f)};
    
    TableCellGroup *group = [[TableCellGroup alloc] init];
    group.headerHeight = 10.0f;
    
    TableCellCustomItem *address = [TableCellCustomItem tableItemWithTitle:nil];
    address.cellHeight = 80.0f;
    address.isSelectionState = NO;
    OrderAddressView *vAddress = [[OrderAddressView alloc] init];
    AddressGoodsDM *dmAddress = [AddressGoodsDM new];
    dmAddress.full_name = self.dmOrder.address;
    dmAddress.name = self.dmOrder.name;
    dmAddress.tel = self.dmOrder.tel;
    
    vAddress.address = dmAddress;
    vAddress.hideArrow = YES;
    address.viewCustom = vAddress;
    address.textCoordX = CGFLOAT_MIN;
    
    TableCellItem *payMode = nil;
    TableCellCustomItem *payment = nil;
    
    payMode = [TableCellItem tableItemWithTitle:nil];
    payMode.cellHeight = 22.0f;
    payMode.isHideSeparator = YES;
    payMode.isSelectionState = NO;
    payMode.textCenter = self.dmOrder.bill_type;
    payMode.textCenterColor = UIColorFromHex(0x333333);
    payMode.titleAttributed = [[NSAttributedString alloc] initWithString:@"支付方式:" attributes:dictAttribute];
    
    if (self.dmOrder.status == OrderStatusWaitPay ||
        self.dmOrder.status == OrderStatusPayProcess) { // 待支付
        payment = [TableCellCustomItem tableItemWithTitle:nil];
        payment.isSelectionState = NO;
        payment.isHideSeparator = YES;
        payment.cellHeight = 40.0f;
        
        OrderDetailPayView *vGoPay = [[OrderDetailPayView alloc] init];
        vGoPay.dmOrder = self.dmOrder;
        payment.viewCustom = vGoPay;
        payment.textCoordX = CGFLOAT_MIN;
    }
    
    TableCellItem *price = [TableCellItem tableItemWithTitle:nil];
    price.cellHeight = 22.0f;
    price.isHideSeparator = YES;
    price.isSelectionState = NO;
    price.textCenter = [NSString stringWithFormat:@"¥%2.f", self.dmOrder.price_total];
    price.textCenterColor = UIColorFromHex(0x333333);
    price.titleAttributed = [[NSAttributedString alloc] initWithString:@"商品合计:" attributes:dictAttribute];
    
    TableCellItem *express = [TableCellItem tableItemWithTitle:nil];
    express.cellHeight = 22.0f;
    express.isHideSeparator = YES;
    express.isSelectionState = NO;
    express.textCenter = [NSString stringWithFormat:@"¥%2.f", self.dmOrder.postage];
    express.textCenterColor = UIColorFromHex(0x333333);
    express.titleAttributed = [[NSAttributedString alloc] initWithString:@"运费:      " attributes:dictAttribute];
    
    TableCellItem *blank = [self cellItemBlack];
    
    if (payment) {
        TableCellItem *blankLine = [self cellItemBlack];
        blankLine.isHideSeparator = NO;
        group.cellItems = @[address, blank, payMode, price, express, blankLine, payment];
    } else {
        group.cellItems = @[address, blank, payMode, price, express, blank];
    }
    return group;
}

- (void)setDmOrder:(OrderDetailDM *)dmOrder
{
    _dmOrder = dmOrder;
    [self.tableView.tableGroups removeAllObjects];
    [self setupGroups];
    [self.tableView reloadData];
}

#pragma mark - ProductCellDelegate
- (void)onRefundEventOrder:(OrderProductDM *)order
{
    
}

@end
