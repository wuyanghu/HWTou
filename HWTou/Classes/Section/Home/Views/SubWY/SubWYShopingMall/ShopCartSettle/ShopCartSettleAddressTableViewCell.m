//
//  ShopCartSettleAddressTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ShopCartSettleAddressTableViewCell.h"

@interface ShopCartSettleAddressTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation ShopCartSettleAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.defaultLabel.layer.borderColor = UIColorFromRGB(0xAD0021).CGColor;//边框颜色
    self.defaultLabel.layer.borderWidth = 1;//边框宽度
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDefaultAddrModel:(GetGoodsAddrListModel *)defaultAddrModel{
    _defaultAddrModel = defaultAddrModel;
    self.nameLabel.text = defaultAddrModel.addrName;
    self.phoneLabel.text = defaultAddrModel.addrPhone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",defaultAddrModel.address,defaultAddrModel.addressDetail];
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"ShopCartSettleAddressTableViewCell";
}
@end
