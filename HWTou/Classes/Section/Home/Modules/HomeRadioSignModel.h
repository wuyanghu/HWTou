//
//  HomeRadioSignModel.h
//  HWTou
//
//  Created by Reyna on 2018/3/29.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface HomeRadioSignModel : BaseModel

@property (nonatomic, assign) int rtcId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bmg;

@end
