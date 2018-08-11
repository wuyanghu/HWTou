//
//  ConsumptionGoldView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PersonalInfoView.h"

@protocol ConsumptionGoldViewDelegate <NSObject>

- (void)onTableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ConsumptionGoldView : UIView

@property (nonatomic, weak) id<ConsumptionGoldViewDelegate> m_Delegate;

- (void)setPersonalInfo:(PersonalInfoDM *)model;
@property (nonatomic, strong) UITableView *m_TableView;

@end
