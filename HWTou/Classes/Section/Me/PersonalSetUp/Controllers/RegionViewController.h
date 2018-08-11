//
//  RegionViewController.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

#import "RegionRequest.h"

@interface RegionViewController : BaseViewController

- (id)initWithType:(RegionType)regionType withDataSource:(NSDictionary *)dic;

@end
