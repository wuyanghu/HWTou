//
//  SubCommentViewController.h
//  HWTou
//
//  Created by Reyna on 2017/11/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "PlayerCommentModel.h"
#import "PlayerHistoryModel.h"
#import "PlayerDetailViewModel.h"

@interface SubCommentViewController : BaseViewController

@property (nonatomic, strong) PlayerCommentModel *model;
@property (nonatomic, strong) PlayerHistoryModel *historyModel;
@property (nonatomic,strong) PlayerDetailViewModel * playerDetailViewModel;
@end
