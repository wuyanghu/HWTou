//
//  ActivityListCell.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityListDM;
@class ActivityCollectDM;

@interface ActivityListCell : UITableViewCell

@property (nonatomic, strong) ActivityListDM *dmList;

@end
