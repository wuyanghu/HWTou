//
//  SubWYAuctionMarginViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SubWYAuctionMarginViewController.h"
#import "PublicHeader.h"
#import "SubWYAuctionPayWayViewController.h"
#import "ShopMallRequest.h"

@interface SubWYAuctionMarginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *commodityImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *marginLabel;

@end

@implementation SubWYAuctionMarginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"保证金"];
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataInit{
    [self.commodityImageView sd_setImageWithURL:[NSURL URLWithString:_goodsListModel.imgUrl]];
    self.nameLabel.text = _goodsListModel.goodsName;
    self.descLabel.text = _goodsListModel.introduction;
    self.sellerLabel.text = [NSString stringWithFormat:@"商家：%@",_goodsListModel.sellerName];
//    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",_goodsListModel.donePrice];
    self.priceLabel.text = @"";
    
    self.marginLabel.text = [NSString stringWithFormat:@"需缴纳保证金:%@",_goodsListModel.proveMoney];
    [self setLabelTextColor:self.marginLabel length:7];
}

#pragma mark - request
- (void)requestAddProveMoneyOrder{
    AddProveMoneyOrderParam * param = [AddProveMoneyOrderParam new];
    param.acvId = _performGoodsListModel.acvId;
    param.goodsId = _goodsListModel.goodsId;
    param.sellerId = _goodsListModel.sellerId;
    param.proveMoney = _goodsListModel.proveMoney;
    
    [ShopMallRequest addProveMoneyOrder:param Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            SubWYAuctionPayWayViewController * payWayVC = [[SubWYAuctionPayWayViewController alloc] initWithNibName:nil bundle:nil];
            payWayVC.payPrice = _goodsListModel.proveMoney;
            payWayVC.proveOrderId = response.data[@"proveOrderId"];
            [self.navigationController pushViewController:payWayVC animated:YES];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
}

#pragma mark - private mothed

- (void)setLabelTextColor:(UILabel *)label length:(NSInteger)length{
    
    NSRange range = NSMakeRange(0,length);
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:label.text];
    [strAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9A9A9A) range:range];
    [strAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    
    range = NSMakeRange(length,label.text.length-length);
    [strAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xAD0021) range:range];
    [strAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    
    label.attributedText = strAttr;
    
}

#pragma mark - action
- (IBAction)oncePayAction:(id)sender {
    [self requestAddProveMoneyOrder];
}
- (IBAction)licensesAction:(id)sender {
    [self.view makeToast:@"查看协议" duration:2.0f position:CSToastPositionCenter];
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
