//
//  PaymentWayView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PaymentWayView.h"
#import "PaymentWayCell.h"
#import "PaymentRequest.h"
#import "PublicHeader.h"
#import "PaymentWayDM.h"

@interface PaymentWayView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView      *vBottom;
@property (nonatomic, strong) UIButton    *btnBuy;
@property (nonatomic, strong) UILabel     *labRealPrice;
@property (nonatomic, strong) NSIndexPath *selIndexPath;
@property (nonatomic, strong) UIView      *vFooter;

@end

@implementation PaymentWayView

static NSString * const kCellIdNormal   = @"CellIdNormal";
static NSString * const kCellIdGold     = @"CellIdGold";

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
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50.0f;
    self.tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.tableView.separatorColor = [UIColor colorWithWhite:0.88 alpha:1];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[PaymentWayCell class] forCellReuseIdentifier:kCellIdNormal];
    [self.tableView registerClass:[PaymentGoldCell class] forCellReuseIdentifier:kCellIdGold];
    
    self.vBottom = [[UIView alloc] init];
    self.vBottom.backgroundColor = UIColorFromHex(0xfafafa);
    
    [self addSubview:self.tableView];
    [self addSubview:self.vBottom];
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
    [btnPayment setTitle:@"付款" forState:UIControlStateNormal];
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

- (UIView *)vFooter
{
    if (_vFooter == nil) {
        _vFooter = [[UIView alloc] init];
        
        UILabel *labText = [[UILabel alloc] init];
        labText.textColor = UIColorFromHex(0x333333);
        labText.font = FontPFRegular(12.0f);
        labText.text = @"提前花可与第三方支付合并使用";
        
        [_vFooter addSubview:labText];
        [labText makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_vFooter);
            make.leading.equalTo(17.0f);
        }];
    }
    return _vFooter;
}

- (void)setListData:(NSArray<NSArray<PaymentWayDM *> *> *)listData
{
    _listData = listData;
    [self.tableView reloadData];
}

- (void)setRealPrice:(CGFloat)realPrice
{
    _realPrice = realPrice;
    self.labRealPrice.text = [NSString stringWithFormat:@"实付:¥%.2f", realPrice];
}

- (void)setGold:(CGFloat)gold
{
    _gold = gold;
    
    NSArray *items = [self.listData firstObject];
    PaymentWayDM *dmWay = [items firstObject];
    dmWay.selected = (gold > 0) ? YES : NO;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *items = self.listData[section];
    return items.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return self.vFooter;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = self.listData[indexPath.section];
    PaymentWayDM *dmWay = items[indexPath.row];
    if (indexPath.section == 0) {
        PaymentGoldCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdGold];
        [cell setDmWay:dmWay];
        [cell setGold:self.gold];
        return cell;

    } else {
        PaymentWayCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdNormal];
        [cell setDmWay:dmWay];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 45.0f;
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        
        if (self.gold <= 0) {
            [HUDProgressTool showOnlyText:@"提前花余额不足"];
            return;
        }
        NSArray *items = self.listData[indexPath.section];
        PaymentWayDM *dmWay = items[indexPath.row];
        dmWay.selected = !dmWay.selected;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        if (dmWay.selected && self.gold >= self.realPrice) {
            // 如果选了提前花，并且余额足够。不能再选择第三方支付
            
            if (self.selIndexPath) {
                NSArray *items = [self.listData lastObject];
                PaymentWayDM *dmWayOld = items[self.selIndexPath.row];
                dmWayOld.selected = !dmWayOld.selected;
                
                NSArray *indexPaths = [NSArray arrayWithObjects:self.selIndexPath, nil];
                [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                self.selIndexPath = nil;
            }
        }
    } else {
        
        if (self.gold >= self.realPrice) {
            // 如果选了提前花，并且余额足够。不能再选择第三方支付
            NSArray *items = [self.listData firstObject];
            PaymentWayDM *dmProfit = [items firstObject];
            if (dmProfit.selected) {
                [HUDProgressTool showOnlyText:@"您已选择提前花支付"];
                return;
            }
        }
        
        NSArray *items = self.listData[indexPath.section];
        
        if (self.selIndexPath) {
            PaymentWayDM *dmWayOld = items[self.selIndexPath.row];
            dmWayOld.selected = !dmWayOld.selected;
        }
        
        if (self.selIndexPath != indexPath) {
            PaymentWayDM *dmWayNew = items[indexPath.row];
            dmWayNew.selected = !dmWayNew.selected;
        }
        
        NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, self.selIndexPath, nil];
        [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        if (self.selIndexPath != indexPath) {
            self.selIndexPath = indexPath;
        } else {
            self.selIndexPath = nil;
        }
    }
}

#pragma mark - Event
- (void)actionPayment:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onPaymentWay:)]) {
        
        PaymentWay payWay = PaymentWayNone;
        
        // 提前花是否选择
        NSArray *items = [self.listData firstObject];
        PaymentWayDM *dmProfit = [items firstObject];
        if (dmProfit.selected) {
            payWay = PaymentWayProfit;
        }
        
        // 第三方支付
        if (self.selIndexPath) {
            NSArray *items = [self.listData lastObject];
            PaymentWayDM *dmOther = items[self.selIndexPath.row];
            payWay |= dmOther.payWay;
        }
        [self.delegate onPaymentWay:payWay];
    }
}

@end
