//
//  ShopCartTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ShopCartTableViewCell.h"
#import "PublicHeader.h"

@interface ShopCartTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ShopCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.selectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectAction:(id)sender {
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.selectBtn.selected) {
        [self.delegate shopCartTableViewCellAction:_reusltModel listModel:_listModel type:ShopCartTableViewCellTypeAdd];
    }else{
        [self.delegate shopCartTableViewCellAction:_reusltModel listModel:_listModel type:ShopCartTableViewCellTypeDel];
    }
}

- (void)setReusltModel:(GetShopCartListResultModel *)reusltModel{
    _reusltModel = reusltModel;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:reusltModel.imgUrl]];
    self.titleLabel.text = reusltModel.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",reusltModel.actualMoney];
}

@end
