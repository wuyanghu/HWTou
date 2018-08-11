//
//  InvestParam.h
//  HWTou
//
//  Created by 张维扬 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseParam.h"

@interface InvestParam : BaseParam

@end

@interface LuckyMoneyParam : BaseParam
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSNumber *start_page;
@property (nonatomic, strong) NSNumber *pages;
@end

@interface GoldExBannerParam : BaseParam
@property (nonatomic, strong) NSNumber *start_page;
@property (nonatomic, strong) NSNumber *pages;
@end
