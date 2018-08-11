//
//  PersonDynamicStateCell.h
//  HWTou
//
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonHomeDM.h"

@protocol PersonDynamicStateCellDelegate
- (void)likeButtonSelected:(UserDetailModel *)detailModel;
@end

@interface PersonDynamicStateCell : UITableViewCell

@property (nonatomic,weak) id<PersonDynamicStateCellDelegate> dynamicDelegate;
@property (nonatomic,strong) UserDetailModel * detailModel;

@end

