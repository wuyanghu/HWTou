//
//  SetMoneySupCardView.h
//  HWTou
//
//  Created by Reyna on 2018/3/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerDetailViewModel.h"

@protocol SetMoneySupCardViewDelegate
- (void)setMoneySupActionWithTotalPirce:(int)totalPrice payType:(int)payType;
@end

@interface SetMoneySupCardView : UIView
@property (nonatomic,weak) id<SetMoneySupCardViewDelegate> delegate;

@property (nonatomic, copy) dispatch_block_t dismissBlock;

- (instancetype)initWithUserModel:(PlayerDetailViewModel *)model;

- (void)show;

- (void)dismiss;

@end
