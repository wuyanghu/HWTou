//
//  OrderListView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ProductEnjoyCell.h"
#import "OrderListHeader.h"
#import "OrderListFooter.h"
#import "OrderDetailReq.h"
#import "OrderListView.h"
#import "OrderDetailDM.h"
#import "PublicHeader.h"

@interface OrderListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView       *tableView;

@end

@implementation OrderListView

static NSString * const kCellIdentifier = @"CellIdentifier";
static NSString * const kCellIdHeader   = @"CellIdHeader";
static NSString * const kCellIdFooter   = @"CellIdFooter";

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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = CoordXSizeScale(96.0f);
    self.tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ProductEnjoyCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.tableView registerClass:[OrderListHeader class] forHeaderFooterViewReuseIdentifier:kCellIdHeader];
    [self.tableView registerClass:[OrderListFooter class] forHeaderFooterViewReuseIdentifier:kCellIdFooter];
    
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listOrder.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderDetailDM *dmOrder = self.listOrder[section];
    return dmOrder.itemList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderListHeader *vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCellIdHeader];
    vHeader.dmOrder = self.listOrder[section];
    return vHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderDetailDM *dmOrder = self.listOrder[section];
    if (dmOrder.status == OrderStatusWaitPay || dmOrder.status == OrderStatusReapGoods ||
        dmOrder.status == OrderStatusPayProcess || dmOrder.status == OrderStatusWaitComment) {
        OrderListFooter *vFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCellIdFooter];
        vFooter.dmOrder = dmOrder;
        vFooter.delegate = self.delegate;
        return vFooter;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductEnjoyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    OrderDetailDM *dmOrder = self.listOrder[indexPath.section];
    OrderProductDM *dmProduct = dmOrder.itemList[indexPath.row];
    [cell setOrderProduct:dmProduct];
    return cell;
}

- (void)setListOrder:(NSArray *)listOrder
{
    _listOrder = listOrder;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42.0f; // 有10个像素为间距
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    OrderDetailDM *dmOrder = self.listOrder[section];
    if (dmOrder.status == OrderStatusWaitPay || dmOrder.status == OrderStatusReapGoods ||
        dmOrder.status == OrderStatusPayProcess || dmOrder.status == OrderStatusWaitComment) {
        return 40.0f;
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] init];
    detailVC.dmOrder = self.listOrder[indexPath.section];
    [[UIApplication topViewController].navigationController pushViewController:detailVC animated:YES];
}

@end
