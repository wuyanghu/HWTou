//
//  PersonInfoViewController.h
//  HWTou
//  Ta的关注
//  Created by robinson on 2017/11/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonHomeDM.h"
#import "PersonHomePageView.h"

@protocol PersonInfoViewControllerDelegate
- (void)jumpVcDelegate;//跳转
@end

@interface PersonInfoViewController : BaseViewController
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,weak) id<PersonInfoViewControllerDelegate> personInfoDelegate;
@property (nonatomic,strong) PersonHomeDM * personHomeModel;
@property (nonatomic,strong) PersonHomePageView * personHomePageView;
@end
