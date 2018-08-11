//
//  GetAnsNumModel.m
//  HWTou
//
//  Created by robinson on 2018/2/7.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "GetAnsNumModel.h"

@implementation GetAnsNumModel

- (double)getPercentage:(ANSNUMTYPE)ansnumType{
    double totalNum = _ansANum+_ansBNum+_ansCNum;
    switch (ansnumType) {
        case ansAnumType:{
            return _ansANum/totalNum;
        }
            break;
        case ansBnumType:{
            return _ansBNum/totalNum;
        }
            break;
        case ansCnumType:{
            return _ansCNum/totalNum;
        }
            break;
        default:
            break;
    }
}

@end
