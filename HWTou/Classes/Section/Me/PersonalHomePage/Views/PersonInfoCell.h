//
//  PersonInfoView.h
//  HWTou
//
//  Created by robinson on 2017/11/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonHomeDM.h"
#import "BaseTableViewCell.h"

@protocol PersonInfoViewDelegate
- (void)attendViewTapDelegate:(UITapGestureRecognizer *)attendViewTap;
@end

@interface PersonInfoCell : BaseTableViewCell
@property (nonatomic,weak) id<PersonInfoViewDelegate> infoViewDelegate;
@property (nonatomic,strong) PersonHomeDM * personHomeModel;
@end
