//
//  ShopCartSettleLeaveTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/10.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SZTextView.h"
#import "GetShopCartListModel.h"
#import "GetGoodsOrderListModel.h"

@interface ShopCartSettleLeaveFooterView : UITableViewHeaderFooterView<UITextViewDelegate>
+ (NSString *)cellIdentity;
@property (weak, nonatomic) IBOutlet SZTextView *leaveTextView;
@property (nonatomic,strong) GetShopCartListModel * listModel;

@property (nonatomic,strong) GetGoodsOrderListModel * orderListModel;

@property (weak, nonatomic) IBOutlet UIView *orderDetailView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;

@end
