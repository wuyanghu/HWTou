//
//  ShoppingCartHeaderView.h
//  HWTou
//
//  Created by robinson on 2018/4/13.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
+ (NSString *)cellIdentity;
@end
