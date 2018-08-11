//
//  PersonalSetUpView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PSFuncType){
    
    PSFuncType_ConsigneeAddress = 0,    // 收货人地址
    PSFuncType_PwdManage,               // 密码管理
    PSFuncType_SmsPush,                 // 消息推送
    PSFuncType_ClearCache,              // 清除缓存
    PSFuncType_About,                   // 关于
    PSFuncType_Shiled,                   // 屏蔽
    PSFuncType_Addressee,                   // 常用收件人
    PSFuncType_SetPayPswd,                   // 支付密码
    
};

@protocol PersonalSetUpViewDelegate <NSObject>

- (void)onLogOut;
- (void)onCellEventProcessing:(PSFuncType)funcType;

@end

@interface PersonalSetUpView : UIView

@property (nonatomic, weak) id<PersonalSetUpViewDelegate> m_Delegate;

/**
 更新推送开关状态
 */
- (void)rrefreshPushState;

@end

