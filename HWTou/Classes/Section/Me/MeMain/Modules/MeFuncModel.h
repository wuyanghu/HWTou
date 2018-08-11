//
//  MeFuncModel.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,FuncType){
    
    FuncType_MyOrder = 0,           // 我的订单
    FuncType_MyCollection,          // 我的收藏
    FuncType_MemberCenter,          // 会员中心
    FuncType_Activity,              // 活动报名
    FuncType_Coupon,                // 优惠劵
    FuncType_PersonalSetUp,         // 个人设置
    FuncType_CustomerAndFeedback,   // 客服与反馈
    FuncType_InvestFriend,          // 邀请好友
    FuncType_RedPacket,             // 红包
    FuncType_GG,                    // 发耶绿色公约
    FuncType_UserManage,            // 用户管理手册
    FuncType_order,//我的订单
    FuncType_paimai,//我的拍卖
};

@interface MeFuncModel : NSObject

@property (nonatomic, strong) NSString *m_Title;
@property (nonatomic, strong) NSString *m_IcoName;
@property (nonatomic, assign) FuncType m_FuncType;

@end
