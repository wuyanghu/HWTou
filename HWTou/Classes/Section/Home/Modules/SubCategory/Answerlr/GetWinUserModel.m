//
//  GetWinUserModel.m
//  HWTou
//
//  Created by robinson on 2018/2/5.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "GetWinUserModel.h"

@implementation GetWinUserModel

- (NSMutableArray *)userResultModelArr{
    if (!_userResultModelArr) {
        _userResultModelArr = [NSMutableArray new];
    }
    return _userResultModelArr;
}

@end


@implementation GetWinUserResultModel

@end
