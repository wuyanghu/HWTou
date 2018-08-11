//
//  PersonTopicViewController.h
//  HWTou
//  个人动态
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "PersonHomeDM.h"
#import "PersonHomePageView.h"

@class MyTopicListModel;

@protocol PersonTopicViewControllerDelegate
- (void)didTotpicSelectRowAtIndexPath:(MyTopicListModel * )detailModel;
@end

@interface PersonTopicViewController : BaseViewController
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) PersonHomePageButtonType editDataButtonType;
@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,weak) id<PersonTopicViewControllerDelegate> dynamicDeleagte;
@property (nonatomic,strong) PersonHomePageView * personHomePageView;

- (void)requestTopicList:(BOOL)isRefresh;
@end
