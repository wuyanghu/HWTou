//
//  PersonalHomePageViewController.h
//  HWTou
//
//  Created by robinson on 2017/11/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonHomePageView.h"
@interface PersonalHomePageViewController : BaseViewController
@property (nonatomic, assign) BOOL isHost;
@property (nonatomic,assign) PersonHomePageButtonType buttonType;
@property (nonatomic,assign) NSInteger uid;
- (void)refreshView;
@end
