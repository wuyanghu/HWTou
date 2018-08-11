//
//  OrderCommitView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ManageAddressViewController.h"
#import "AddressManageViewController.h"
#import "CouponSelectViewController.h"
#import "OrderAddressView.h"
#import "ProductEnjoyCell.h"
#import "OrderCommitView.h"
#import "AddressGoodsDM.h"
#import "ProductCartDM.h"
#import "PublicHeader.h"
#import "CommonTable.h"

@interface OrderCommitView () <CouponSelectControllerDelegate>

@property (nonatomic, strong) OrderAddressView *vAddress;
@property (nonatomic, strong) CommonTableView *tableView;
@property (nonatomic, strong) UILabel   *labRealPrice;
@property (nonatomic, strong) UIView    *vBottom;

@property (nonatomic, assign) CGFloat   couMoney; // 优惠金额
@property (nonatomic, assign) CGFloat   totalPrice; // 商品总价
@property (nonatomic, assign) CGFloat   postage;    // 快递运费

@end

@implementation OrderCommitView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self setupGroups];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)createUI
{
    self.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.tableView = [[CommonTableView alloc] init];
    self.vBottom = [[UIView alloc] init];
    
    [self addSubview:self.vBottom];
    [self addSubview:self.tableView];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.bottom.equalTo(self.vBottom.top);
    }];
    
    [self.vBottom makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        make.height.equalTo(49);
    }];
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = UIColorFromHex(0xc4c4c4);
    [self addSubview:vLine];
    
    self.labRealPrice = [[UILabel alloc] init];
    self.labRealPrice.textColor = UIColorFromHex(0xb4292d);
    self.labRealPrice.font = FontPFRegular(14.0f);
    
    UIButton *btnPayment = [[UIButton alloc] init];
    btnPayment.titleLabel.font = FontPFRegular(14.0f);
    btnPayment.backgroundColor = UIColorFromHex(0xb4292d);
    [btnPayment setTitle:@"去付款" forState:UIControlStateNormal];
    [btnPayment addTarget:self action:@selector(actionPayment:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.vBottom addSubview:vLine];
    [self.vBottom addSubview:btnPayment];
    [self.vBottom addSubview:self.labRealPrice];
    
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.vBottom);
        make.height.equalTo(Single_Line_Width);
    }];
    
    [self.labRealPrice makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vBottom);
        make.leading.equalTo(self.vBottom).offset(15.0f);
    }];
    
    [btnPayment makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(self.vBottom);
        make.width.equalTo(self.vBottom).multipliedBy(0.33);
    }];
}

- (OrderAddressView *)vAddress
{
    if (_vAddress == nil) {
        _vAddress = [[OrderAddressView alloc] init];
    }
    return _vAddress;
}

// 初始化模型数据
- (void)setupGroups
{
    NSDictionary *dictAttribute = @{NSForegroundColorAttributeName : UIColorFromHex(0x333333),
                                    NSFontAttributeName : FontPFRegular(14.0f)};
    
    TableCellGroup *group1 = [[TableCellGroup alloc] init];
    group1.headerHeight = 1.0f;
    
    WeakObj(self);
    if (self.dmAddress) {
        TableCellCustomItem *address = [TableCellCustomItem tableItemWithTitle:nil];
        address.cellDidSelectHandle = ^{
            [selfWeak handleAddress];
        };
        address.cellHeight = 80;
        address.isHideSeparator = YES;
        address.viewCustom = self.vAddress;
        address.textCoordX = CGFLOAT_MIN;
        
        group1.cellItems = @[address];
    } else {
        
        NSAttributedString *attrAddress = [[NSAttributedString alloc] initWithString:@"收货地址" attributes:dictAttribute];
        TableCellArrowItem *address = [TableCellArrowItem tableItemWithTitle:nil];
        address.titleAttributed = attrAddress;
        address.detailTitleColor = UIColorFromHex(0x7f7f7f);
        address.detailTitle = @"去新建";
        address.isHideSeparator = YES;
        
        address.cellDidSelectHandle = ^{
            [selfWeak handleCreateAddress];
        };
        group1.cellItems = @[address];
    }
    
    
    [self.vAddress setAddress:self.dmAddress];
    
    TableCellGroup *group2 = [[TableCellGroup alloc] init];
    group2.headerHeight = 10.0f;
    
    NSString *strCoupon = @"优惠券: 未选择";
    
    if (self.couMoney > 0) {
        strCoupon = [NSString stringWithFormat:@"优惠券: 抵扣%.2f元",  self.couMoney];
    }
    
    TableCellArrowItem *coupon = [TableCellArrowItem tableItemWithTitle:nil];
    NSAttributedString *attrCoupon = [[NSAttributedString alloc] initWithString:strCoupon attributes:dictAttribute];
    coupon.detailTitle = [NSString stringWithFormat:@"%d张", (int)self.coupons.count];
    coupon.detailTitleColor = UIColorFromHex(0x7f7f7f);
    coupon.titleAttributed = attrCoupon;
    coupon.isHideSeparator = YES;
    coupon.cellDidSelectHandle = ^{
        [selfWeak handleCoupon];
    };
    
    group2.cellItems = @[coupon];
    
    TableCellGroup *group3 = [[TableCellGroup alloc] init];
    group3.headerHeight = 10.0f;
    
    TableCellLabelItem *price = [TableCellLabelItem tableItemWithTitle:nil];
    
    NSAttributedString *attrPrice = [[NSAttributedString alloc] initWithString:@"商品合计" attributes:dictAttribute];
    price.titleAttributed = attrPrice;
    price.isSelectionState = NO;
    price.detailTitleColor = UIColorFromHex(0x333333);
    price.detailTitle = [NSString stringWithFormat:@"¥%.2f", self.totalPrice];
    
    TableCellLabelItem *postage = [TableCellLabelItem tableItemWithTitle:nil];
    NSAttributedString *attrPostage = [[NSAttributedString alloc] initWithString:@"运费" attributes:dictAttribute];
    postage.titleAttributed = attrPostage;
    postage.isSelectionState = NO;
    postage.isHideSeparator = YES;
    postage.detailTitleColor = UIColorFromHex(0x333333);
    postage.detailTitle = [NSString stringWithFormat:@"¥%.2f", self.postage];
    
    group3.cellItems = @[price, postage];
    
    NSMutableArray *products = [NSMutableArray array];
    for (int index = 0; index < self.carts.count; index++) {
        TableCellCustomItem *product = [TableCellCustomItem tableItemWithTitle:nil];
        product.cellHeight = 96.0f;
        product.textCoordX = CGFLOAT_MIN;
        product.isHideSeparator = YES;
        
        ProductEnjoyCell *cell = [[ProductEnjoyCell alloc] init];
        [cell setCartProduct:self.carts[index]];
        product.viewCustom = cell;
        [products addObject:product];
    }
    TableCellGroup *group4 = [[TableCellGroup alloc] init];
    group4.headerHeight = 10.0f;
    group4.footerHeight = 10.0f;
    group4.cellItems = products;
    
    [self.tableView.tableGroups addObjectsFromArray:@[group1, group2, group3, group4]];
}

- (void)setCarts:(NSArray<ProductCartDM *> *)carts
{
    _carts = carts;
    
    self.postage = 0;
    self.totalPrice = 0;
    
    [self.carts enumerateObjectsUsingBlock:^(ProductCartDM *obj, NSUInteger idx, BOOL *stop) {
        CGFloat price = obj.price * obj.num; // 商品单价*数量
        self.totalPrice += price;
        if (obj.postage > self.postage) { // 最高邮费为准
            self.postage = obj.postage;
        }
    }];
    
    [self calculatePrice];
    [self reloadTableData];
}

- (void)setCoupons:(NSArray<CouponSelDM *> *)coupons
{
    _coupons = coupons;
    [self reloadTableData];
}

- (void)setAddress:(NSArray<AddressGoodsDM *> *)address
{
    _address = address;
    self.dmAddress = [address firstObject];
    [self reloadTableData];
}

// 计算商品价格
- (void)calculatePrice
{
    // 实付价格 = 所有商品总价 + 邮费 - 抵价券金额
    self.realPrice = self.totalPrice + self.postage - self.couMoney;
    self.labRealPrice.text = [NSString stringWithFormat:@"实付:¥%.2f", self.realPrice];
}

- (void)setRealPrice:(CGFloat)realPrice
{
    if (realPrice < 0) {
        realPrice = 0;
    }
    // 只取两位小数
    _realPrice = floor(realPrice*100)/100;
}

- (void)reloadTableData
{
    [self.tableView.tableGroups removeAllObjects];
    
    [self setupGroups];
    [self.tableView reloadData];
}

- (void)handleCreateAddress
{
    ManageAddressViewController *addressVC = [[ManageAddressViewController alloc] init];
    addressVC.blockAddress = ^(AddressGoodsDM *address) {
        self.dmAddress = address;
        [self reloadTableData];
    };
    [[UIApplication topViewController].navigationController pushViewController:addressVC animated:YES];
}

- (void)handleAddress
{
    AddressManageViewController *addressVC = [[AddressManageViewController alloc] init];
    addressVC.blockAddress = ^(AddressGoodsDM *address) {
        self.dmAddress = address;
        [self reloadTableData];
    };
    
    addressVC.deleteAddress = ^(AddressGoodsDM *address) {
        if (self.dmAddress.maid == address.maid) {
            self.dmAddress = nil;
            [self reloadTableData];
        }
    };
    
    addressVC.modifyAddress = ^(AddressGoodsDM *address) {
        if (self.dmAddress.maid == address.maid) {
            self.dmAddress = address;
            [self reloadTableData];
        }
    };
    
    [[UIApplication topViewController].navigationController pushViewController:addressVC animated:YES];
}

- (void)handleCoupon
{
    CouponSelectViewController *couponVC = [[CouponSelectViewController alloc] init];
    couponVC.coupons = self.coupons;
    couponVC.m_Delegate = self;
    couponVC.totalPrice = self.totalPrice + self.postage;
    [self.viewController.navigationController pushViewController:couponVC animated:YES];
}

#pragma mark - CouponSelectControllerDelegate
- (void)onDidSelectCoupons:(NSArray<CouponSelDM *> *)coupons
{
    self.couMoney = 0;
    
    [self.coupons enumerateObjectsUsingBlock:^(CouponSelDM *obj, NSUInteger idx, BOOL *stop) {
        obj.selected = NO;
    }];
    
    [coupons enumerateObjectsUsingBlock:^(CouponSelDM *coupon, NSUInteger idx, BOOL *stop) {
        self.couMoney += [coupon.rule doubleValue];
        
        [self.coupons enumerateObjectsUsingBlock:^(CouponSelDM *obj, NSUInteger idx, BOOL *stop) {
            if (coupon.cuid == obj.cuid) {
                obj.selected = YES;
                *stop = YES;
            }
        }];
    }];
    
    [self reloadTableData];
    [self calculatePrice];
    [[UIApplication topViewController].navigationController popViewControllerAnimated:YES];
}

- (void)actionPayment:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onPaymentEvent)]) {
        [self.delegate onPaymentEvent];
    }
}

@end
