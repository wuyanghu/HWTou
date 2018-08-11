//
//  GetHotRecListModel.m
//  HWTou
//
//  Created by robinson on 2017/12/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "GetHotRecListModel.h"

@implementation GetHotRecListModel

- (NSMutableArray<GuessULikeModel *> *)rtcDetailArr{
    if (!_rtcDetailArr) {
        _rtcDetailArr = [NSMutableArray array];
    }
    return _rtcDetailArr;
}

@end
