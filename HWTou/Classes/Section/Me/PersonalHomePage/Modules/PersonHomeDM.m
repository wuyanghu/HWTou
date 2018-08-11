//
//  PersonHomeDM.m
//  HWTou
//
//  Created by robinson on 2017/11/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonHomeDM.h"
#import "AccountManager.h"

@implementation PersonHomeDM

//得到性别
- (NSString *)getSex{
    if (_sex == 1) {
        return @"男生";
    }else if (_sex == 2){
        return @"女生";
    }else{
        if (_isSelf) {
            return @"请选择性别";
        }else{
            return @"保密";
        }
    }
}
//设置性别
- (NSInteger)setSexInt:(NSString *)sexStr{
    if ([sexStr isEqualToString:@"男生"]) {
        return 1;
    }else if ([sexStr isEqualToString:@"女生"]){
        return 2;
    }else{
        return 0;
    }
}

- (NSString *)getCity{
    if (_city != nil && ![_city isEqualToString:@""]) {
        return _city;
    }
    if (_isSelf) {
        return @"请选择城市";
    }else{
        return @"保密";
    }
    
}

- (NSString *)getSign{
    if (_sign != nil && ![_sign isEqualToString:@""]) {
        return _sign;
    }
    return @"暂无签名";
}

- (NSArray *)getBgBmgs{
    NSArray * imgArray;
    if (_bmgs != nil && ![_bmgs isEqualToString:@""]) {
        imgArray = [_bmgs componentsSeparatedByString:@","];
    }else{
        imgArray = @[@"bg_img_1"];
    }
    return imgArray;
}

- (NSInteger)isSelfUid{
    AccountManager *manager = [AccountManager shared];
    if (_uid == [manager account].uid) {
        return 0;
    }
    return _uid;
}

@end

@implementation FocusUserListDM

@end

@implementation CityInfoModel

@end

@implementation UserDetailModel

- (BOOL)getIsPraise{
    if (_isPaise == 0) {
        return NO;
    }
    return YES;
}

@end
