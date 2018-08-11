//
//  RadioProgramDetailCell.h
//  HWTou
//
//  Created by robinson on 2017/11/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioProgramDetailCell : UITableViewCell

@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIButton * playStateBtn;//点击可回放，直播，预约
@property (nonatomic,strong) UILabel * timeLabel;

@property (nonatomic,strong) NSDictionary * dataDict;

@end
