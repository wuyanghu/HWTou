//
//  AddresseeListTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/12.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AddresseeListTableViewCell.h"

@implementation AddresseeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.setDefaultBtn setImage:[UIImage imageNamed:@"sq_btn_no"] forState:UIControlStateNormal];
    [self.setDefaultBtn setImage:[UIImage imageNamed:@"sq_btn_ye"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGetGoodsAddrListModel:(GetGoodsAddrListModel *)getGoodsAddrListModel{
    _getGoodsAddrListModel = getGoodsAddrListModel;
    self.nameLabel.text = _getGoodsAddrListModel.addrName;
    self.telLabel.text = _getGoodsAddrListModel.addrPhone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",_getGoodsAddrListModel.address,_getGoodsAddrListModel.addressDetail];
    self.setDefaultBtn.selected = _getGoodsAddrListModel.isDef==1;
}

- (IBAction)setDefaultAction:(id)sender {
    if (!self.setDefaultBtn.selected) {
        if (_getGoodsAddrListModel.isDef == 0) {
            [self.delegate addresseeListCellAction:_getGoodsAddrListModel];
        }
    }
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"AddresseeListTableViewCell";
}
@end
