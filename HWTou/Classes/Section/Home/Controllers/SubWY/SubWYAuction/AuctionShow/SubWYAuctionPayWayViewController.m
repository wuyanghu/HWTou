//
//  SubWYAuctionPayWayViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/10.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SubWYAuctionPayWayViewController.h"
#import "MuteRequest.h"
#import "QuickRegistrationViewController.h"
#import "RedPacketRequest.h"
#import "YYModel.h"
#import "MoneyInfoRequest.h"
#import "AccountManager.h"
#import "MoneyAccountModel.h"
#import "IPAddrTool.h"
#import <Pingpp.h>
#import "PayWayView.h"
#import "UIView+NTES.h"

typedef enum : NSUInteger{
    payBtnTypeAccount,
    payBtnTypeAlipay,
    payBtnTypeWechat,
}PayBtnType;

@interface SubWYAuctionPayWayViewController ()<PayWayViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *accountBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;

@property (nonatomic,strong) NSArray * payBtnArray;
@property (nonatomic,assign) PayBtnType payBtnType;
@property (nonatomic,strong) PayWayView * payWayView;
@end

@implementation SubWYAuctionPayWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"支付方式"];
    
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataInit{
    for (UIButton * btn in self.payBtnArray) {
        [btn setImage:[UIImage imageNamed:@"xuanzhong_address"] forState:UIControlStateSelected];
    }
    [self setBtnSelected:payBtnTypeAccount];
    self.priceLabel.text = [NSString stringWithFormat:@"实付：¥%@",_payPrice];
    
    [self balanceRequest];
}

#pragma mark -  request
//余额
- (void)balanceRequest {
    NSInteger uid = [AccountManager shared].account.uid;
    [MoneyInfoRequest getUserAccountWithUid:uid success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            NSDictionary *dataDic =[response objectForKey:@"data"];
            MoneyAccountModel *accountModel = [[MoneyAccountModel alloc] init];
            [accountModel bindWithDic:dataDic];
            
            _availableBalanceLabel.text = accountModel.balance;
        }
    } failure:^(NSError *error) {
        
    }];
}

//保证金
- (void)requestPayProveOrder:(PayProveOrderParam *)param{
    [RedPacketRequest payProveOrder:param Success:^(RedPacketResponseDict *response) {
        if (response.status == 200) {
            [self.view makeToast:@"支付成功" duration:2.0f position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
}

//拍卖品
- (void)requestPaySellerGoodsOrder:(PaySellerGoodsOrderParam *)param{
    [RedPacketRequest paySellerGoodsOrder:param Success:^(RedPacketResponseDict *response) {
        if (response.status == 200) {
            [self.view makeToast:@"支付成功" duration:2.0f position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
   
}

#pragma mark - action

- (IBAction)accountAction:(id)sender {
    [self setBtnSelected:payBtnTypeAccount];
}

- (IBAction)alipayAction:(id)sender {
    [self setBtnSelected:payBtnTypeAlipay];
}

- (IBAction)wechatAction:(id)sender {
    [self setBtnSelected:payBtnTypeWechat];
}

- (IBAction)goPayAction:(id)sender {
    if (_isSeller) {
        [self payWaySeller];
    }else{
        [self payWayMargin];
    }
}

#pragma mark - delegate

- (void)payWaySuccess{
    if (_isSeller) {
        PaySellerGoodsOrderParam * param = [PaySellerGoodsOrderParam new];
        param.chargeId = @"";
        param.chargeType = 0;
        param.sellerGoodsOrderId = _proveOrderId;
        
        [self requestPaySellerGoodsOrder:param];
    }else{
        PayProveOrderParam * param = [PayProveOrderParam new];
        param.chargeId = @"";
        param.chargeType = 0;
        param.proveOrderId = _proveOrderId;
        [self requestPayProveOrder:param];
    }
}

#pragma mark - private mothed
//拍卖品
- (void)payWaySeller{
    if (_payBtnType == payBtnTypeAccount) {
        [MuteRequest isSetPayPwd:^(AnswerLsInt *response) {
            if (response.status == 200) {
                if (response.data == 1) {
                    [self.payWayView show];
                }else{
                    //进入支付密码，设置支付密码
                    QuickRegistrationViewController * pswdVC = [[QuickRegistrationViewController alloc] init];
                    pswdVC.type = QuickRegistrationTypePayPswd;
                    [self.navigationController pushViewController:pswdVC animated:YES];
                }
            }else{
                [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
        }];
    }else if (_payBtnType == payBtnTypeAlipay){
        ChargeSellerGoodsOrderParam * param = [ChargeSellerGoodsOrderParam new];
        param.chargeType = 1;
        param.ip = [IPAddrTool getIPAddress:YES];
        param.sellerGoodsOrderId = _proveOrderId;
        
        [RedPacketRequest chargeSellerGoodsOrder:param Success:^(RedPacketResponseDict * response) {
            if (response.status == 200) {
                NSString *chargeId = [response.data objectForKey:@"chargeId"];
                NSString *charge = [response.data objectForKey:@"charge"];
                
                [Pingpp createPayment:charge
                       viewController:self
                         appURLScheme:@"HWTou"
                       withCompletion:^(NSString *result, PingppError *error) {
                           if ([result isEqualToString:@"success"]) {
                               PaySellerGoodsOrderParam * param = [PaySellerGoodsOrderParam new];
                               param.chargeId = chargeId;
                               param.chargeType = 1;
                               param.sellerGoodsOrderId = _proveOrderId;
                               [self requestPaySellerGoodsOrder:param];
                           } else {
                               // 支付失败或取消
                               NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
                               //                                   [HUDProgressTool showSuccessWithText:@"支付失败或取消"];
                           }
                       }];
            }else{
                [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
            }
        } failure:^(NSError * error) {
            [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
        }];
    }
}

//保证金支付
- (void)payWayMargin{
    if (_payBtnType == payBtnTypeAccount) {
        [MuteRequest isSetPayPwd:^(AnswerLsInt *response) {
            if (response.status == 200) {
                if (response.data == 1) {
                    [self.payWayView show];
                }else{
                    //进入支付密码，设置支付密码
                    QuickRegistrationViewController * pswdVC = [[QuickRegistrationViewController alloc] init];
                    pswdVC.type = QuickRegistrationTypePayPswd;
                    [self.navigationController pushViewController:pswdVC animated:YES];
                }
            }else{
                [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
            }
        } failure:^(NSError *error) {
            [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
        }];
    }else if (_payBtnType == payBtnTypeAlipay){
        ChargeProveMoneyParam * param = [ChargeProveMoneyParam new];
        param.chargeType = 1;
        param.ip = [IPAddrTool getIPAddress:YES];
        param.proveOrderId = _proveOrderId;
        
        [RedPacketRequest chargeProveMoney:param Success:^(RedPacketResponseDict * response) {
            if (response.status == 200) {
                NSString *chargeId = [response.data objectForKey:@"chargeId"];
                NSString *charge = [response.data objectForKey:@"charge"];
                
                [Pingpp createPayment:charge
                       viewController:self
                         appURLScheme:@"HWTou"
                       withCompletion:^(NSString *result, PingppError *error) {
                           if ([result isEqualToString:@"success"]) {
                               PayProveOrderParam * param = [PayProveOrderParam new];
                               param.chargeId = chargeId;
                               param.chargeType = 1;
                               param.proveOrderId = _proveOrderId;
                               [self requestPayProveOrder:param];
                           } else {
                               // 支付失败或取消
                               NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
                               //                                   [HUDProgressTool showSuccessWithText:@"支付失败或取消"];
                           }
                       }];
            }else{
                [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
            }
        } failure:^(NSError * error) {
            [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
        }];
    }
}

- (void)setBtnSelected:(PayBtnType)type{
    _payBtnType = type;
    
    self.accountBtn.selected = type == payBtnTypeAccount;
    self.alipayBtn.selected = type == payBtnTypeAlipay;
    self.wechatBtn.selected = type == payBtnTypeWechat;
}

#pragma mark - getter

- (PayWayView *)payWayView{
    if (!_payWayView) {
        _payWayView = [[[NSBundle mainBundle] loadNibNamed:@"PayWayView" owner:self options:nil] lastObject];
        _payWayView.frame = CGRectMake(0, UIScreenHeight, self.view.ntesWidth, UIScreenHeight);
        _payWayView.delegate = self;
    }
    return _payWayView;
}

- (NSArray *)payBtnArray{
    if (!_payBtnArray) {
        _payBtnArray = @[self.accountBtn,self.alipayBtn,self.wechatBtn];
    }
    return _payBtnArray;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
