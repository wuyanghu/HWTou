//
//  GetQuestionBankInfoModel.m
//  HWTou
//
//  Created by robinson on 2018/2/1.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "GetQuestionBankInfoModel.h"

@implementation GetQuestionBankInfoModel

- (NSMutableArray *)quesOptionArr{
    if (!_quesOptionArr) {
        _quesOptionArr = [NSMutableArray array];
    }
    return _quesOptionArr;
}

@end


@implementation QuesOptionsModel

@end
