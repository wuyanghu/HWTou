//
//  HWTAPI.h
//  baianlicai
//
//  Created by rdmacmini on 17/6/5.  6.6
//  Copyright © 2017年 Yosef Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ServiceCommon.h"
#import "RdAppError.h"

@protocol HWTAPIDelegate <NSObject>
/**
 *  登录，注册，修改密码， 忘记密码 回调
 *
 *  @param data 返回数据
 *  @param actionType 回调类型
 
 */
-(void)didFinishLoginOrRegisterWithUserInfo:(NSDictionary *)data ActionType:(actionType)actionType;


-(void)getInvestRecordList:(NSDictionary *)data;

@end

@interface HWTAPI : NSObject

@property (nonatomic, assign) id <HWTAPIDelegate> delegate;


-(void)initHWTParamsWithPhone:(NSString *)phone withPwd:(NSString *)pwd withAappKey:(NSString*)appKey withAppSecret:(NSString *)appSecret useProductionServer:(BOOL)useProductionServer;

-(NSDictionary *)getUserInfo;


/**
 *  获取体验标详情页
 *
 *  @param controller 起跳VC
 *  @param moduleType 产品类型
 *  @param borrowId 产品ID
 *  @param money 提前花提示参数

 */
- (void)jumpToExpBorrowDetailFromVC:(UIViewController *)controller withModuleType:(ProductType)moduleType withBorrowId:(NSString *)borrowId withMoneyFromHWT:(NSString *)money;
/**
 *  获取普通产品详情数据
 *
 *  @param controller 起跳VC
 *  @param moduleType 产品类型
 *  @param borrowId 产品ID
 *  @param money 提前花提示参数

 */
- (void)jumpToProductDetailFromVC:(nullable UIViewController*)controller withModuleType:(ProductType)moduleType withBorrowId:(NSString *)borrowId withMoneyFromHWT:(NSString *)money;

/**
 *  获取产品列表数据
 *
 *  @param page 页数
 */
- (void)getProductListWithPageNumber:(NSInteger)page result:(void(^) (NSDictionary *dataDic, RdAppError *error))resultCallBack;

/**
 *  获取投资管理数据
 *
 *  @param page 页数
 */
-(void)getUserTenderLogListWithPageNumber:(NSInteger)page result:(void(^) (NSDictionary *dataDic, RdAppError *error))resultCallBack;

/**
 *  获取账户基础信息
 *
 *  返回数据
 *  @param accountAmountTotal 我的资产
 *  @param incomeCollected 已收收益
 *  @param incomeCollecting 待到账收益
*/

- (void)getUserInfoCallBack :(void(^) (NSDictionary *dataDic, RdAppError *error))resultCallBack;;
/**
 *  获取产品列表界面
 *
 *  @param controller 起跳VC
 */
-(UIViewController *)getProductSegmentVC;

/**
 *  跳转到登录界面
 *
 *  @param controller 起跳VC
 */
-(void)jumpToLoginVC:(UIViewController *)controller;
/**
 *  跳转到注册界面
 *
 *  @param controller 起跳VC
 */
- (void)jumpToRegisterVC:(UIViewController *)controller  fromVC:(UIViewController *)fromVC;


/**
 *  重置登录密码
 *
 *  @param controller 起跳VC
 */
-(void)jumpToResetLoginPasswordVCFromVC:(UIViewController *)controller;


/**
 *  跳转到产品列表
 *
 *  @param controller 起跳VC
 */
- (void)jumpToProductList:(UIViewController *)controller;
/**
 *  跳转到借款管理
 *
 *  @param controller 跳转VC
 */
-(void)jumpToLoanManageFromVC:(UIViewController *)controller;

/**
 *  跳转到资产统计界面
 *
 *  @param controller 起跳VC
 */
-(void)jumpToAssetStatisticsFromVC:(UIViewController *)controller;

/**
 *  跳转到转让控制器
 *
 *  @param controller 起跳VC
 */
-(void)jumpToTransferSegementFromVC:(UIViewController *)controller;

/**
 *  跳转到回款控制器
 *
 *  @param controller 起跳VC
 */
-(void)jumpToPaybackSegementFromVC:(UIViewController *)controller;

/**
 *  跳转到绑定邮箱界面
 *
 *  @param controller 起跳VC
 */
-(void)jumpToBindingEmailVCFromVC:(UIViewController *)controller;
/**
 *  跳转到开通支付账户
 *
 *  @param controller 起跳VC
 */
-(void)jumpToAccountRealNameTableViewControllerFromVC:(UIViewController *)controller;


/**
 *  跳转到充值界面
 *
 *  @param controller 起跳VC
 */
-(void)jumpToRechargeTableViewControllerFromVC:(UIViewController *)controller;

/**
 *  跳转到提现界面
 *
 *  @param controller 起跳VC
 */
-(void)jumpToCashTableViewControllerFromVC:(UIViewController *)controller;

/**
 *  跳转到充值提现记录控制器
 *
 *  @param controller 起跳VC
 */
-(void)jumpToRechargeRecordSegementVCFromVC:(UIViewController *)controller withIndex:(recordType)index;

/**
 *  跳转到投资管理控制器
 *
 *  @param controller 起跳VC
 */
-(void)jumpToInvestmentManagementSegementVCFromVC:(UIViewController *)controller;


/**
 *  我的银行卡
 *
 *  @param controller VC
 */
-(void)jumpToMyBankListVCFromVC:(UIViewController *)controller;

/**
 *  跳转到 红包segement
 *
 *  @param controller 起跳VC
 */
-(void)jumpToCouponsSegementFromVC:(UIViewController *)controller;
/**
 *  跳转到 体验金
 *
 *  @param controller 起跳VC
 */
-(void)jumpToExpListFromVC:(UIViewController *)controller;


-(void)jumpToProtrcolWebVCFromVC:(UIViewController *)controller withUrl:(NSString *)url;
-(void)showRdAlertView:(UserType) type FromVC:(UIViewController *)controller;


/**
 *  退出登录
 *
 *  @param controller 起跳VC
 *  @param sender id

 */
-(void)userLogout:(id)sender FromVC:(UIViewController *)controller;

/**
 *  自动登录
 *
 *  @param controller 起跳VC
 *  @param isOK isOK为YES自动登录成功

 */
-(void)autoLoginActionFrom:(UIViewController *)fromVC result:(void (^)(BOOL isOK))result;
/**
 *  初始化 产品列表的数据
 *
 *  @param DataArray 提前花数据
 
 *  数据格式：@{@"ID":@"1047",@"apr":@"1",@"isShow":@"YES"}
 *  @param ID 标ID
 *  @param apr 提前花年利率
 *  @param isShow 是否显示提前花的图标 ，YES为展示

 */

-(void)initProductListDataWithDataArray:(NSMutableArray *)DataArray;

@property(nonatomic,strong)NSMutableArray *dataArr;

+(HWTAPI*)sharedInstance;

@end
