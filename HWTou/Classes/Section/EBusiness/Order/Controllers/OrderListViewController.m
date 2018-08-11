//
//  OrderListViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCommentViewController.h"
#import "OrderListViewController.h"
#import "OrderMailViewController.h"
#import "OrderDetailReq.h"
#import "OrderListView.h"
#import "PublicHeader.h"

@interface OrderListViewController () <OrderListDelegate>

@property (nonatomic, strong) OrderListView *vOrderList;

@end

@implementation OrderListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.vOrderList = [[OrderListView alloc] init];
    self.vOrderList.delegate = self;
    [self.view addSubview:self.vOrderList];
    
    [self.vOrderList makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    WeakObj(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [selfWeak loadListData:YES];
    }];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.vOrderList.tableView.mj_header = header;
}

- (void)setStatus:(OrderStatusType)status
{
    _status = status;
    self.vOrderList.listOrder = nil;
    
    [HUDProgressTool showIndicatorWithText:@"加载中..."];
    [self loadListData:YES];
}

- (void)loadListData:(BOOL)refresh
{
    OrderListParam *param = [OrderListParam new];
    param.status = self.status;
    param.order_nos = self.keywords;
    param.start_page = refresh ? 0 : self.vOrderList.listOrder.count;
    param.pages = 10;
    
    [OrderDetailReq listWithParam:param success:^(OrderListResp *response) {
        
        [HUDProgressTool dismiss];
        if (refresh) {
            self.vOrderList.listOrder = response.data.list;
            if (self.keywords.length > 0 && response.data.list.count == 0) {
                [HUDProgressTool showOnlyText:@"未搜索到内容，换个关键词试试"];
            }
        } else {
            NSMutableArray *tempData = [NSMutableArray arrayWithArray:self.vOrderList.listOrder];
            [tempData addObjectsFromArray:response.data.list];
            self.vOrderList.listOrder = tempData;
        }
        BOOL isMore = self.vOrderList.listOrder.count < response.data.total_pages ? YES : NO;
        [self setLoadMore:isMore];
        [self handleLoadCompleted];
    } failure:^(NSError *error) {
        [self handleLoadCompleted];
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)setLoadMore:(BOOL)isMore
{
    if (isMore) {
        WeakObj(self);
        self.vOrderList.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak loadListData:NO];
        }];
    } else {
        self.vOrderList.tableView.mj_footer = nil;
    }
}

// 更新视图状态显示
- (void)handleLoadCompleted
{
    [self.vOrderList.tableView.mj_header endRefreshing];
    [self.vOrderList.tableView.mj_footer endRefreshing];
}

#pragma mark - OrderListFooterDelegate
- (void)onOrderEvent:(OrderEvent)event order:(OrderDetailDM *)dmOrder
{
    switch (event) {
        case OrderEventCancel:
            [self handleCancelOrder:dmOrder];
            break;
        case OrderEventMail:
            [self handleOrderMail:dmOrder];
            break;
        case OrderEventConfirm:
            [self handleConfirmGoods:dmOrder];
            break;
        case OrderEventComment:
            [self handleComment:dmOrder];
            break;
        default:
            break;
    }
}

- (void)handleComment:(OrderDetailDM *)dmOrder
{
    ProductCommentViewController *commentVC = [[ProductCommentViewController alloc] init];
    commentVC.listData = dmOrder.itemList;
    commentVC.mpid = dmOrder.mpid;
    [[UIApplication topViewController].navigationController pushViewController:commentVC animated:YES];
}

- (void)handleOrderMail:(OrderDetailDM *)dmOrder
{
    OrderMailViewController *mailVC = [[OrderMailViewController alloc] init];
    mailVC.dmOrder = dmOrder;
    [[UIApplication topViewController].navigationController pushViewController:mailVC animated:YES];
}

- (void)handleConfirmGoods:(OrderDetailDM *)dmOrder
{
    [self showAlertWithTitle:@"确认是否收到货?" msg:nil handler:^{
        [HUDProgressTool showIndicatorWithText:nil];
        OrderComParam *param = [OrderComParam new];
        param.mpid = dmOrder.mpid;
        
        [OrderDetailReq confirmWithParam:param success:^(BaseResponse *response) {
            if (response.success) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [HUDProgressTool dismiss];
                    [self loadListData:YES];
                });
            } else {
                [HUDProgressTool showOnlyText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    }];
}

- (void)handleCancelOrder:(OrderDetailDM *)dmOrder
{
    [self showAlertWithTitle:@"确定取消订单?" msg:nil handler:^{
        [HUDProgressTool showIndicatorWithText:nil];
        OrderComParam *param = [OrderComParam new];
        param.mpid = dmOrder.mpid;
        
        [OrderDetailReq cancelWithParam:param success:^(BaseResponse *response) {
            if (response.success) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [HUDProgressTool dismiss];
                    [self loadListData:YES];
                });
            } else {
                [HUDProgressTool showOnlyText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    }];
}

- (void)showAlertWithTitle:(NSString *)title msg:(NSString *)msg handler:(void (^)(void))handler
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !handler ?: handler();
    }];
    
    [alertVC addAction:actionCancel];
    [alertVC addAction:actionOK];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)vtm_prepareForReuse
{
    // 子控制器被重用时，清除旧数据、修正页面偏移等逻辑处理
    self.vOrderList.listOrder = nil;
    self.vOrderList.tableView.mj_footer = nil;
}
@end
