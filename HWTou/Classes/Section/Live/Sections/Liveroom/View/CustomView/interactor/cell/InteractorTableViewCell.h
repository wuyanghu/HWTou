//
//  InteractorTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/3/21.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
@class NTESMicConnector;

@protocol InteractorTableViewCellDelegate
- (void)muteAction:(NTESMicConnector *)micConnector flag:(NSInteger)flag;
- (void)connectAction:(NTESMicConnector *)micConnector flag:(NSInteger)flag;
@end

@interface InteractorTableViewCell : BaseTableViewCell
@property (nonatomic,weak) id<InteractorTableViewCellDelegate> cellDelegate;
@property (nonatomic,strong) NTESMicConnector * micConnector;
@end
