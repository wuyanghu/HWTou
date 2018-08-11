//
//  MeEarningHeaderView.h
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyEarningViewModel.h"

@interface MeEarningHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong) UILabel * totalIncomeLabel;
@property (nonatomic,strong) UILabel * canExtractIncome;

@property (nonatomic,strong) MoneyEarningViewModel *viewModel;
@end

@interface MeEarningTitleHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong) UILabel * titleLabel;
@end
