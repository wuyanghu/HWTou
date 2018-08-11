//
//  PayDetailView.m
//  HWTou
//
//  Created by pengpeng on 17/3/17.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "PaymentWayViewController.h"
#import "AddressGoodsDM.h"
#import "OrderAddressView.h"
#import "ProductListCell.h"
#import "PayDetailView.h"
#import "OrderDetailDM.h"
#import "PublicHeader.h"

@interface PayDetailHeader : UICollectionReusableView

@property (nonatomic, strong) OrderDetailDM *dmOrder;

@end

@interface PayDetailView ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    PayDetailHeader  *_vHeader;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PayDetailView

static  NSString * const kCellIdentifier = @"CellIdentifier";
static  NSString * const kCellIdHeader   = @"CellIdHeader";

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
#if 0
    CGFloat itemW = kMainScreenWidth * 0.5;
    CGFloat itemH = itemW * 1.2;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.headerReferenceSize = CGSizeMake(kMainScreenWidth, 300);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[ProductListCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self.collectionView registerClass:[PayDetailHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCellIdHeader];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self addSubview:self.collectionView];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
#else
    _vHeader = [[PayDetailHeader alloc] init];
    self.backgroundColor = UIColorFromHex(0xf4f4f4);
    [self addSubview:_vHeader];
    
    [_vHeader makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
#endif
}

- (void)setDmOrder:(OrderDetailDM *)dmOrder
{
    _dmOrder = dmOrder;
    _vHeader.dmOrder = dmOrder;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                          withReuseIdentifier:kCellIdHeader
                                                                 forIndexPath:indexPath];
    }
    return reusableview;
}

@end

@interface PayDetailHeader ()
{
    UIView  *_vPayResult;   // 付款结果
    UIView  *_vPayMoney;    // 支付现金
    UIView  *_vOtherBuy;    // 其他推荐
    OrderAddressView *_vAddress; // 收货地址
    
    UIButton    *_btnOrder;
    UIButton    *_btnGoPay;
    
    UILabel     *_labResult;
    UILabel     *_labPayway;
    UILabel     *_labRealPay;
}
@end

@implementation PayDetailHeader

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
    _vPayResult = [[UIView alloc] init];
    _vPayResult.backgroundColor = [UIColor whiteColor];
    
    UILabel *labResult = [[UILabel alloc] init];
    labResult.textColor = UIColorFromHex(0xb4292d);
    labResult.font = FontPFRegular(15.0f);
    _labResult = labResult;
    
    UIButton *btnOrder = [[UIButton alloc] init];
    [btnOrder setTitleColor:UIColorFromHex(0xb4292d) forState:UIControlStateNormal];
    [btnOrder setTitle:@"查看订单" forState:UIControlStateNormal];
    btnOrder.titleLabel.font = FontPFRegular(15.0f);
    btnOrder.layer.borderColor = UIColorFromHex(0xb4292d).CGColor;
    [btnOrder addTarget:self action:@selector(actionOrderDetail) forControlEvents:UIControlEventTouchUpInside];
    btnOrder.layer.borderWidth = 1.0f;
    [btnOrder setRoundWithCorner:4.0f];
    _btnOrder = btnOrder;
    
    _btnGoPay = [[UIButton alloc] init];
    [_btnGoPay setRoundWithCorner:4.0f];
    _btnGoPay.titleLabel.font = FontPFRegular(13);
    [_btnGoPay setTitle:@"重新付款" forState:UIControlStateNormal];
    [_btnGoPay setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xb4292d)] forState:UIControlStateNormal];
    [_btnGoPay addTarget:self action:@selector(actionGoPay) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_vPayResult];
    [_vPayResult addSubview:labResult];
    [_vPayResult addSubview:btnOrder];
    [_vPayResult addSubview:_btnGoPay];
    
    [_vPayResult makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(100);
    }];
    
    [_btnOrder makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vPayResult.centerY);
        make.size.equalTo(_vPayResult).multipliedBy(0.3);
        make.trailing.equalTo(_vPayResult.centerX).offset(-10);
    }];
    
    [_btnGoPay makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.equalTo(_btnOrder);
        make.leading.equalTo(_vPayResult.centerX).offset(10);
    }];
    
    [labResult makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_vPayResult);
        make.bottom.equalTo(btnOrder.top).offset(-10);
    }];
    
    _vAddress = [[OrderAddressView alloc] init];
    _vAddress.hideArrow = YES;
    [self addSubview:_vAddress];
    
    [_vAddress makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vPayResult.bottom).offset(10);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(80.0f);
    }];
    
    // 支付方式和金额相关
    UILabel *labPayWay = [self createLabel:@"支付方式:"];
    UILabel *labMoney = [self createLabel:@"实付:"];
    labMoney.textColor = UIColorFromHex(0x7f7f7f);
    labPayWay.textColor = UIColorFromHex(0x7f7f7f);
    
    _labPayway = [self createLabel:nil];
    _labRealPay = [self createLabel:nil];
    
    _vPayMoney = [[UIView alloc] init];
    _vPayMoney.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_vPayMoney];
    [_vPayMoney addSubview:labPayWay];
    [_vPayMoney addSubview:labMoney];
    [_vPayMoney addSubview:_labPayway];
    [_vPayMoney addSubview:_labRealPay];
    
    [_vPayMoney makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vAddress.bottom).offset(10);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(70.0f);
    }];
    
    [labPayWay makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_vPayMoney).offset(16.0f);
        make.bottom.equalTo(_vPayMoney.centerY).offset(-2.0f);
    }];
    
    [_labPayway makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labPayWay);
        make.leading.equalTo(_vPayMoney.trailing).multipliedBy(0.25);
    }];
    
    [labMoney makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(labPayWay);
        make.top.equalTo(_vPayMoney.centerY).offset(2.0f);
    }];
    
    [_labRealPay makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_labPayway);
        make.centerY.equalTo(labMoney);
    }];
    
#if 0
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = UIColorFromHex(0xc4c4c4);
    
    UILabel *labOther = [self createLabel:@"其他人也在买"];
    
    _vOtherBuy = [[UIView alloc] init];
    _vOtherBuy.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_vOtherBuy];
    [_vOtherBuy addSubview:vLine];
    [_vOtherBuy addSubview:labOther];
    
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(_vOtherBuy);
        make.height.equalTo(Single_Line_Width);
    }];
    
    [_vOtherBuy makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vPayMoney.bottom).offset(10);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(40.0f);
    }];
    
    [labOther makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_vOtherBuy);
    }];
#endif
}

- (void)setDmOrder:(OrderDetailDM *)dmOrder
{
    _dmOrder = dmOrder;
    if (dmOrder.status == OrderStatusWaitPay) {
        _labResult.text = @"付款失败";
    } else {
        _labResult.text = @"付款成功";
        _btnGoPay.hidden = YES;
        
        [_btnOrder remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_vPayResult);
            make.top.equalTo(_vPayResult.centerY);
            make.size.equalTo(_vPayResult).multipliedBy(0.3);
        }];
    }
    
    _labPayway.text = dmOrder.bill_type;
    _labRealPay.text = [NSString stringWithFormat:@"¥%.2f", dmOrder.price_total];
    
    AddressGoodsDM *dmAddres = [[AddressGoodsDM alloc] init];
    dmAddres.full_name = self.dmOrder.address;
    dmAddres.name = self.dmOrder.name;
    dmAddres.tel = self.dmOrder.tel;
    
    _vAddress.address = dmAddres;
}

- (void)actionOrderDetail
{
    OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] init];
    detailVC.dmOrder = self.dmOrder;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}

- (void)actionGoPay
{
    PaymentWayViewController *detailVC = [[PaymentWayViewController alloc] init];
    detailVC.dmOrder = self.dmOrder;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}

- (UILabel *)createLabel:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromHex(0x333333);
    label.font = FontPFRegular(14.0f);
    label.text = text;
    return label;
}
@end
