//
//  RegisterInfoFillView.h
//  HWTou
//
//  Created by robinson on 2017/11/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RegisterInfoFillViewDelegate <NSObject>
- (void)skipToHomePage;//跳转到首页
@end


@interface RegisterInfoFillView : UIView
@property (nonatomic,copy) NSString * phone;//手机号
@property (nonatomic,copy) NSString * pwd;//密码
@property (nonatomic,copy) NSString * imgCode;
@property (nonatomic,assign) NSInteger smsCode;

@property (nonatomic,weak) id<RegisterInfoFillViewDelegate> registerInfoFillViewDelegate;
@end
