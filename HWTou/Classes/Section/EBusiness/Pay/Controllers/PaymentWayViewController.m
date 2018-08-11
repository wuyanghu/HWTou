//
//  PaymentWayViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PaymentWayViewController.h"
#import "PayDetailViewController.h"
#import "PayThirdManager.h"
#import "PersonalInfoReq.h"
#import "PersonalInfoDM.h"
#import "PaymentWayView.h"
#import "OrderDetailReq.h"
#import "OrderDetailDM.h"
#import "PaymentWayDM.h"
#import "PublicHeader.h"

@interface PaymentWayViewController () <PaymentWayDelegate>

@property (nonatomic, copy) PayCompletedBlock blockPay;
@property (nonatomic, strong) PaymentWayView *vPayWay;
@property (nonatomic, assign) CGFloat gold; // 提前花余额

@end

@implementation PaymentWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setupData];
    [self loadData];
}

- (void)createUI
{
    self.title = @"收银台";
    
    self.vPayWay = [[PaymentWayView alloc] init];
    self.vPayWay.delegate = self;
    [self.view addSubview:self.vPayWay];
    
    [self.vPayWay makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - PaymentWayDelegate
- (void)onPaymentWay:(PaymentWay)way
{
    if (way == PaymentWayNone) {
        [HUDProgressTool showOnlyText:@"请选择支付方式"];
        return;
    }
    if (way == PaymentWayProfit && self.gold < self.dmOrder.price_total) {
        [HUDProgressTool showOnlyText:@"提前花余额不足，请选择其他支付方式"];
        return;
    }
    
    if (way & PaymentWayCard) {
        [HUDProgressTool showOnlyText:@"暂不支持银行卡支付"];
        return;
    }
    
    if (self.dmOrder.price_total <= 0) {
        // 支持金额0的情况，强制走提前花接口，不要调用第三方支付
        self.dmOrder.price_total = 0;
        way = PaymentWayProfit;
    }
    
    if (self.dmOrder.status == OrderStatusPayProcess) {
        // 付款中的状态，可能是订单回滚失败，需要重新回滚状态
        [self orderRollBackCompleted:^(BOOL success) {
            if (success) {
                [self startPaymentWithWay:way];
            }
        }];
    } else {
        [self startPaymentWithWay:way];
    }
}

- (void)startPaymentWithWay:(PaymentWay)way
{
    CGFloat gold_expense = 0;
    if (way & PaymentWayProfit) { // 优先使用提前花
        gold_expense = (self.gold >= self.dmOrder.price_total) ? self.dmOrder.price_total : self.gold;
    }
    
    [HUDProgressTool showIndicatorWithText:nil];
    PaymentParam *param = [PaymentParam new];
    param.type = way;
    param.mpid = self.dmOrder.mpid;
    param.gold_expense = gold_expense;
    param.union_expense = self.dmOrder.price_total - gold_expense;
    
    [PaymentRequest paymentWithParam:param success:^(BaseResponse *response) {
        if (response.success) {
            [HUDProgressTool dismiss];
            
            if (way & PaymentWayAliPay) {
                [self handleAlipay];
            } else if (way & PaymentWayWXPay) {
                [self handleWechatPay];
            } else {
                [self jumpPayDetailVC];
            }
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)handleAlipay
{
    [HUDProgressTool showIndicatorWithText:nil];
    PayThirdParam *param = [[PayThirdParam alloc] init];
    param.mpid = self.dmOrder.mpid;
    [PaymentRequest alipayWithParam:param success:^(PayAliResp *response) {
        if (response.success) {
            [HUDProgressTool dismiss];
            [PayThirdManager aliPayWithOrder:response.data.order_string completed:^(BOOL success, NSString *msg) {
                [self handleThirdPay:success msg:msg];
            }];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)handleWechatPay
{
    [HUDProgressTool showIndicatorWithText:nil];
    PayThirdParam *param = [[PayThirdParam alloc] init];
    param.mpid = self.dmOrder.mpid;
    [PaymentRequest wxpayWithParam:param success:^(PayWechatResp *response) {
        if (response.success) {
            [HUDProgressTool dismiss];
            [PayThirdManager wxPayWithParam:response.data completed:^(BOOL success, NSString *msg) {
                [self handleThirdPay:success msg:msg];
            }];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)handleThirdPay:(BOOL)success msg:(NSString *)msg
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUDProgressTool showOnlyText:msg];
    });
    if (success) {
        [self jumpPayDetailVC];
    } else {
        [self orderRollBackCompleted:^(BOOL success) {
            [self jumpPayDetailVC];
        }];
    }
}

// 回滚订单处理
- (void)orderRollBackCompleted:(void (^)(BOOL success))completed
{
    [HUDProgressTool showIndicatorWithText:nil];
    OrderComParam *param = [[OrderComParam alloc] init];
    param.mpid = self.dmOrder.mpid;
    
    [OrderDetailReq rollBackWithParam:param success:^(BaseResponse *response) {
        
        if (response.success) {
            [HUDProgressTool dismiss];
        } else {
            [HUDProgressTool showOnlyText:response.msg];
        }
        !completed ?: completed(response.success);
        
    } failure:^(NSError *error) {
        !completed ?: completed(NO);
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)jumpPayDetailVC
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    PayDetailViewController *detailVC = [[PayDetailViewController alloc] init];
    detailVC.mpid = self.dmOrder.mpid;
    [[UIApplication topViewController].navigationController pushViewController:detailVC animated:YES];
}

- (void)setupData
{
    PaymentWayDM *cash = [[PaymentWayDM alloc] init];
    cash.imgName = @"shop_pay_way_cash";
    cash.title = @"提前花";
    cash.payWay = PaymentWayProfit;
    
    PaymentWayDM *card = [[PaymentWayDM alloc] init];
    card.imgName = @"shop_pay_way_card";
    card.payWay = PaymentWayCard;
    card.title = @"银行卡";
    
    PaymentWayDM *aliPay = [[PaymentWayDM alloc] init];
    aliPay.imgName = @"shop_pay_way_ali";
    aliPay.payWay = PaymentWayAliPay;
    aliPay.title = @"支付宝";
    
    if ([PayThirdManager isWeixinInstalled]) {
        PaymentWayDM *wxPay = [[PaymentWayDM alloc] init];
        wxPay.imgName = @"shop_pay_way_wx";
        wxPay.payWay = PaymentWayWXPay;
        wxPay.title = @"微信";
        
        self.vPayWay.listData = @[@[cash], @[card, aliPay, wxPay]];
    } else {
        self.vPayWay.listData = @[@[cash], @[card, aliPay]];
    }
    self.vPayWay.realPrice = self.dmOrder.price_total;
}

- (void)loadData
{
    [HUDProgressTool showIndicatorWithText:@"加载中..."];
    [PersonalInfoReq personalInfoSuccess:^(PersonalInfoResp *response) {
        self.gold = response.data.gold;
        [self.vPayWay setGold:response.data.gold];
        [HUDProgressTool dismiss];
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

@end
