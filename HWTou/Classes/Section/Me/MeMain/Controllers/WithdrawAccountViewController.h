//
//  WithdrawAccountViewController.h
//  HWTou
//
//  Created by Reyna on 2018/2/6.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "WithdrawAccountInfoModel.h"

@protocol WithdrawAccountInfoDelegate
- (void)didCommitAccountInfoModel:(WithdrawAccountInfoModel *)model;
@end

@interface WithdrawAccountViewController : BaseViewController
@property (nonatomic,weak) id<WithdrawAccountInfoDelegate> delegate;

@end
