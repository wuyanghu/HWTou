//
//  AddresseeListTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/12.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GetGoodsAddrListModel.h"

@protocol AddresseeListTableViewCellDelegate
- (void)addresseeListCellAction:(GetGoodsAddrListModel *)addrModel;
@end

@interface AddresseeListTableViewCell : BaseTableViewCell

@property (nonatomic,weak) id<AddresseeListTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *setDefaultBtn;
@property (nonatomic,strong) GetGoodsAddrListModel * getGoodsAddrListModel;
@end
