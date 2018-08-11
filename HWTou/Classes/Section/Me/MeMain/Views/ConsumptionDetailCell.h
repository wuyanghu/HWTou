//
//  ConsumptionDetailCell.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ConsumptionDetailCellID (@"ConsumptionDetailCellID")

@class ConsumpGoldDetailDM;
@class ConsumExtracDetailDM;

@interface ConsumptionDetailCell : UITableViewCell

@property (nonatomic, strong) ConsumpGoldDetailDM *dmDetail;

@property (nonatomic, strong) ConsumExtracDetailDM *dmExtracDetail;

@end
