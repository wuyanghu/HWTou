//
//  WorkBenchViewController.h
//  HWTou
//
//  Created by robinson on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "WorkBenchView.h"
#import "TopicWorkDetailModel.h"

@interface WorkBenchViewController : BaseViewController
@property (nonatomic,strong) TopicWorkDetailModel * detailModel;
@property (nonatomic,assign) WorkType workType;

@end
