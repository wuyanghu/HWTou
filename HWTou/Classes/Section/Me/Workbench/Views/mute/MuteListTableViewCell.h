//
//  MuteListTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol MuteListTableViewCellDelegate
- (void)onMuteAction:(NSDictionary *)itemDict button:(UIButton *)button;
@end

@interface MuteListTableViewCell : BaseTableViewCell
@property (nonatomic,strong) NSDictionary * itemDict;
@property (nonatomic,weak) id<MuteListTableViewCellDelegate> cellDelegate;
@end
