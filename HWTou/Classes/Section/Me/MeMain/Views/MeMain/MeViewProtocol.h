//
//  MeViewProtocol.h
//  HWTou
//
//  Created by robinson on 2017/12/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeFuncModel.h"
@class PersonHomeDM;

@protocol MeViewProtocol <NSObject>
- (void)onPersonalInfo;//跳转到个人主页信息
- (void)onFunctionalResponse:(FuncType)funcType withPersonalInfo:(PersonHomeDM *)model;
- (void)tapGestureFloor:(UITapGestureRecognizer *)tapGesture;
- (void)buttonSelected:(UIButton *)button;
@end
