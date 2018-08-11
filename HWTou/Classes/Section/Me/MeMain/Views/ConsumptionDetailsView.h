//
//  ConsumptionDetailsView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PersonalInfoView.h"

@interface ConsumptionDetailsView : UIView

- (void)setPersonalInfo:(PersonalInfoDM *)model;

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, copy) NSArray *listData;

@end
