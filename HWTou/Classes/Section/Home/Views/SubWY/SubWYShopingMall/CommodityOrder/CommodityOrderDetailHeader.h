//
//  CommodityOrderDetailHeader.h
//  HWTou
//
//  Created by robinson on 2018/4/17.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityOrderDetailHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+ (NSString *)cellIdentity;
@end
