//
//  SetPwdView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OperationType){
    
    OperationType_Reg = 0,          // 注册密码
    OperationType_Change,           // 更改密码 （密码找回）

};

@protocol SetPwdViewDelegate <NSObject>

- (void)onRegSuccessful;
- (void)onChangePwdSuccessful;

@end

@interface SetPwdView : UIView

@property (nonatomic, weak) id<SetPwdViewDelegate> m_Delegate;

- (void)setOperationType:(OperationType)type withPhone:(NSString *)phone
             withVerCode:(NSString *)verCode;

@end
