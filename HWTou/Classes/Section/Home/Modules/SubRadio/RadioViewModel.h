//
//  RadioViewModel.h
//  HWTou
//
//  Created by Reyna on 2017/11/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "RadioModel.h"
#import "TopicWorkDetailModel.h"

@interface RadioViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray<RadioModel *> *dataArr;

@end

