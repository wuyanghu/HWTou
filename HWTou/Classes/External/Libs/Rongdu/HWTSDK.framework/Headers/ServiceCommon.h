//
//  ServiceCommon.h
//  demoapp
//
//  Created by Yosef Lin on 2/18/16.
//  Copyright © 2016 Yosef Lin. All rights reserved.
//

#ifndef ServiceCommon_h
#define ServiceCommon_h

#import <Foundation/Foundation.h>


/**
 *  回调类型
 */
typedef NS_ENUM(NSInteger, actionType) {
    /**
     *  登录、注册
     */
    loginOrRegisterAction = 0,
    
    /**
     *  忘记密码
     */
    ForgetPwdAction = 1,
    /**
     *  修改密码
     */
    resetPwdAction = 2
};

/**
 *  记录类型
 */
typedef NS_ENUM(NSInteger, recordType) {
    /**
     *  充值
     */
    recharge = 0,
   
    /**
     *  提现
     */
    cash = 1
};
/**
 *  产品状态
 */
typedef NS_ENUM(NSInteger, ProductStatus) {
    /**
     *  审核中
     */
    ProductStatusApproving = -2,
    /**
     *  初审未通过
     */
    ProductStatusUnapprove = -1,
    /**
     *  投标中
     */
    ProductStatusNormal = 0,
    /**
     *  还款中
     */
    ProductStatusRepayment = 1
};
/**
 *  债权转让状态
 */
typedef NS_ENUM(NSInteger, AssignedClaimStatus) {
    /**
     *  转让中，可撤回
     */
    AssignedClaimStatusAssigning = 0,
    /**
     *  已撤回
     */
//    AssignedClaimStatusWithdraw = 1,
    /**
     *  已转让，不可撤回
     */
    AssignedClaimStatusAssigned = 2
};

/**
 *  优惠券列表状态
 */
typedef NS_ENUM(NSUInteger, CouponsTableViewType) {
    /**
     *  默认显示优惠券
     */
    CouponsTableViewTypeDefault = 0,
    /**
     *  选择优惠券
     */
    CouponsTableViewTypeSelect = 1
};

/**
 *  优惠券状态 使用状态 0 未使用|未审核 1已使用｜已审核 2冻结 3过期 4 关闭|｜未通过 5已使用
 */
typedef NS_ENUM(NSInteger, CouponsStatus) {
    /**
     *  可使用
     */
    CouponsStatusDefault = 0,
    /**
     *  已使用
     */
    CouponsStatusHadUse = 1,
    
    CouponsStatusFrozen = 2,
    /**
     *  已过期
     */
    CouponsStatusExpire = 3,
    
    CouponsStatusInvalid = 4,
    
    CouponsStatusHadUsed = 5,
    
    
};
/**
 *  banner图点击事件
 */
typedef NS_ENUM(NSInteger, ActionType) {
    /**
     *  不做任何事情
     */
    ActionTypeNoting = 0,
    /**
     *  跳网页
     */
    ActionTypeWeb = 1,
    /**
     *  跳项目详情
     */
    ActionTypeTender = 2,
    /**
     *  跳内部其他页面
     */
    ActionTypeNative = 3
};
/**
 *  错误类型
 */
typedef NS_ENUM(NSInteger, RdAppErrorType) {
    
    /**
     *  缺少必要参数
     */
    RdAppErrorTypeMissingParameters = -3,
    
    /**
     *  网络错误
     */
    RdAppErrorTypeNetwork = -2,
    
    /**
     *  数据转换错误
     */
    RdAppErrorTypeTransform = -1,
    
    /**
     *  业务上操作失败
     */
    RdAppErrorTypeOperationFailure = 0,
    
    /**
     *  成功
     */
    RdAppErrorTypeSuccess = 1,
    
    /**
     *  实名认证
     */
    RdAppErrorTypeOpenPay = 528,
    
    /**
     *  token不存在，无效的token
     */
    RdAppErrorTypeTokenInvalid = 2,
    
    /**
     *  token过期
     */
    RdAppErrorTypeTokenExpiredTime= 3,
    
    /**
     *  用户被冻结 锁定
     */
    RdAppErrorTypeUserFrozen = 532,
    
    /**
     *  部分功能冻结 （充值 提现 投资 等）
     */
    RdAppErrorTypeUserInvestFrozen = 545,
    /**
     *  token不匹配(sessionId丢失)a
     */
    RdAppErrorTypeTokenMismatch= 1027,
    
    /**
     *  绑定银行卡
     */
    RdAlertViewTypeOpenBankNum= 3,
    
    /**
     *  邮箱认证
     */
    RdAlertViewTypeOpenEmail= 4,
    
    /**
     *余额
     */
    RdAlertViewTypeUsemMney= 5,

    /**
     *手机认证
     */
    RdAlertViewTypePhone= 6,
};

/**
 *  用户类型
 */
typedef NS_ENUM(NSInteger , UserType) {
    
    /**
     *  正常用户
     */
    NormalUser = 1,
    
    /**
     *  未实名用户
     */
    NeedOpenPay = 100,
    
    /**
     *  未绑卡用户
     */
    NeedOpenBank = 101,
    
    /**
     *  余额不足用户
     */
    NeedRechargeMoney = 102,
    
    /**
     *  未设置交易密码
     */
    NeedSetPayPassWord = 103,
    
   
    
};

/**
 *  获取手机验证码的类型
 */
typedef NS_ENUM(NSInteger, PhoneCodeType) {
    /**
     *  忘记密码
     */
    PhoneCodeTypeForgetPassword = 0,
    /**
     *  注册
     */
    PhoneCodeTypeRegister = 1,
};

/**
 *  邮箱验证码类型值
 */
typedef NS_ENUM(NSInteger, EmailCodeType) {
    /**
     *  忘记密码
     */
    EmailCodeTypeForgetPassword = 0,
    /**
     *  注册
     */
    EmailCodeTypeRegister = 1,
};

/**
 *  账户类型值
 */
typedef NS_ENUM(NSInteger, AccountType) {
    /**
     *  手机号码
     */
    AccountTypePhone = 0,
    /**
     *  邮箱
     */
    AccountTypeEmail = 1,
    /**
     *  用户名
     */
    AccountTypeNickname = 2
};

/**
 *  红包类型
 */
typedef NS_ENUM(NSInteger, CouponsType) {
    /**
     *  红包
     */
    CouponsTypeRedEnvelopes = 0,
    /**
     *  体验金
     */
    CouponsTypeExperiences = 1,
    /**
     *  加息券
     */
    CouponsTypeUpRates = 2
};

/**
 *  产品周期类型
 */
typedef NS_ENUM(NSInteger, DurationType) {
    /**
     *  月
     */
    DurationTypeMonth  = 0,
    /**
     *  日
     */
    DurationTypeDay    = 1,
};

/**
 *  产品类型值
 */
typedef NS_ENUM(NSInteger, ProductType) {
    /**
     *  普通产品
     */
    ProductTypeNormal = 0,
    /**
     *  流转
     */
    ProductFlow = 1,
    /**
     *  债权转让
     */
    ProductTypeCreditAssignment = 2
};

/**
 *  消息状态
 */
typedef NS_ENUM(NSInteger, MessageStatus) {
    /**
     *  删除
     */
    MessageStatusDelete = 3,
    /**
     *  未读
     */
    MessageStatusUnread = 1,
    /**
     *  已读
     */
    MessageStatusHadread = 2
};

typedef NS_ENUM(NSInteger, GestureViewType) {
    
    EditGesturePwdType = 1,
    
    ResetGesturePwdType = 2,
    
    ValidateGesturePwdType = 3,
    
    DeleteGesturePwdType = 4,
    
    NoneType = 5,
    
};
#endif /* ServiceCommon_h */
