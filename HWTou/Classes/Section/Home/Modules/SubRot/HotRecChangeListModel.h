//
//  tHotRecChangeListModel.h
//  HWTou
//
//  Created by robinson on 2017/12/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseModel.h"
#import "GuessULikeModel.h"

@interface HotRecChangeListModel : BaseModel
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSMutableArray<GuessULikeModel *> * rtcDetailListArr;
@end
