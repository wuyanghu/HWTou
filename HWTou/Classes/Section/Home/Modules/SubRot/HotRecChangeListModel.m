//
//  tHotRecChangeListModel.m
//  HWTou
//
//  Created by robinson on 2017/12/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HotRecChangeListModel.h"

@implementation HotRecChangeListModel

- (NSMutableArray<GuessULikeModel *> *)rtcDetailListArr{
    if (!_rtcDetailListArr) {
        _rtcDetailListArr = [[NSMutableArray alloc] init];
    }
    return _rtcDetailListArr;
}

@end
