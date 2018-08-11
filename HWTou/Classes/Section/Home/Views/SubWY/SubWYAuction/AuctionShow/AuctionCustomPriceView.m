//
//  AuctionCustomPriceView.m
//  HWTou
//
//  Created by robinson on 2018/4/24.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AuctionCustomPriceView.h"
#import "UIView+NTES.h"
#import "UIView+Toast.h"

@implementation AuctionCustomPriceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.raisePriceLabel.layer.borderWidth = 1;
    self.raisePriceLabel.layer.borderColor = UIColorFromRGB(0xAD0021).CGColor;
    
    self.addPriceBtn.layer.borderWidth = 1;
    self.addPriceBtn.layer.borderColor = UIColorFromRGB(0xAD0021).CGColor;
    
    self.subPriceBtn.layer.borderWidth = 1;
    self.subPriceBtn.layer.borderColor = UIColorFromRGB(0xAD0021).CGColor;
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.bgView addGestureRecognizer:tapGesturRecognizer];
    
}

-(void)tapAction:(id)tap{
    [self dismiss];
}

- (void)show:(GoodsListModel * )goodsListModel
{
    _goodsListModel = goodsListModel;
    [self refreshView];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.ntesTop -= self.ntesHeight;
    }];
    
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.ntesTop += self.ntesHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - action

- (IBAction)addPriceAction:(id)sender {
    self.raisePriceLabel.text = [NSString stringWithFormat:@"%.2f",[self.raisePriceLabel.text doubleValue]+[_goodsListModel.courierMoney doubleValue]];
    self.offerPriceLabel.text = [NSString stringWithFormat:@"%.2f",[self.currentPriceLabel.text doubleValue]+[self.raisePriceLabel.text doubleValue]];
}

- (IBAction)subPriceAction:(id)sender {
    double offerPrice = [self.currentPriceLabel.text doubleValue]+[self.raisePriceLabel.text doubleValue];
    if (offerPrice<=[[_goodsListModel getCurrentPrice] doubleValue]) {
        [self makeToast:@"出价价格不能低于当前报价" duration:2.0f position:CSToastPositionCenter];
        return;
    }
    self.raisePriceLabel.text = [NSString stringWithFormat:@"%.2f",[self.raisePriceLabel.text integerValue]-[_goodsListModel.courierMoney doubleValue]];
    self.offerPriceLabel.text = [NSString stringWithFormat:@"%.2f",[self.currentPriceLabel.text doubleValue]+[self.raisePriceLabel.text doubleValue]];
    
}

- (IBAction)surePriceAction:(id)sender {
    [self dismiss];
    [self.delegate auctionCustomPriceViewAction:self.offerPriceLabel.text];
}


#pragma mark - private mothod

- (void)refreshView{
    self.currentPriceLabel.text = [_goodsListModel getCurrentPrice];
    self.raisePriceLabel.text = _goodsListModel.courierMoney;
    self.offerPriceLabel.text = [NSString stringWithFormat:@"%.2f",[self.currentPriceLabel.text doubleValue]+[self.raisePriceLabel.text doubleValue]];
}
@end
