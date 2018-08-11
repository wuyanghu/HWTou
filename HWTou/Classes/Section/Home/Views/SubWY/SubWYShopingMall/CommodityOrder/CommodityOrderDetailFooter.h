//
//  CommodityOrderDetailFooter.h
//  HWTou
//
//  Created by robinson on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetGoodsOrderListModel.h"

@protocol CommodityOrderDetailFooterDelegate
- (void)orderCancelPayAction:(NSInteger)old;
- (void)orderSurePayAction:(GetGoodsOrderListModel *)getGoodsOrderListModel;
@end

@interface CommodityOrderDetailFooter : UITableViewHeaderFooterView
@property (nonatomic,weak) id<CommodityOrderDetailFooterDelegate> delegate;
@property (nonatomic,strong) GetGoodsOrderListModel * getGoodsOrderListModel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *countTimeLabel;

+ (NSString *)cellIdentity;
@end
