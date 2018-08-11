//
//  AuctionOrderStateFooterView.h
//  HWTou
//
//  Created by robinson on 2018/4/23.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetMySellerListModel.h"

@interface AuctionOrderStateFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *labelState;

@property (nonatomic,strong) GetMySellerListModel * listModel;
+ (NSString *)cellIdentity;
@end
