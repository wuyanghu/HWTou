//
//  RadioTypeCell.h
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
#import "RadioClassViewModel.h"

@protocol RadioClassTypeDelegate <NSObject>

- (void)radioClassSelectAction:(RadioClassModel *)model;

@end

@interface RadioTypeCell : BaseCell

@property (nonatomic, copy) void(^showMoreOrHiddenBlock)(RadioTypeCell *cell);

@property (nonatomic, weak) __weak id<RadioClassTypeDelegate> delegate;

+ (NSString *)cellReuseIdentifierInfo;

- (void)bind:(RadioClassViewModel *)viewModel;

@end
