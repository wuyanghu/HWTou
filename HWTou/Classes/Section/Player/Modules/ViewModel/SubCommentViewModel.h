//
//  SubCommentViewModel.h
//  HWTou
//
//  Created by Reyna on 2017/11/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "SubCommentModel.h"

@interface SubCommentViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray <SubCommentModel *>* dataArr;
@end
