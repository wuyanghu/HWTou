//
//  RewardTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/3/28.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RewardModel.h"

@interface RewardTableViewCell : BaseTableViewCell
@property (nonatomic,strong) RewardModel * rewardModel;
- (void)refresh:(RewardModel *)rewardModel selectRow:(NSInteger)selectRow;
@end
