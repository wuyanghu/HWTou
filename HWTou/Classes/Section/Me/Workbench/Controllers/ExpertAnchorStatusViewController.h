//
//  ExpertAnchorStatusViewController.h
//  HWTou
//
//  Created by robinson on 2017/12/18.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ExpertAnchorStatusViewControllerBlock)();

@interface ExpertAnchorStatusViewController : BaseViewController
@property (nonatomic,assign) NSInteger checkStatus;//审核状态，0：审核中，1：审核通过，2：审核拒绝, 4:未申请
@property (nonatomic,copy) ExpertAnchorStatusViewControllerBlock statusVCBlock;
@end
