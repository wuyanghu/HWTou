//
//  RongduManager.m
//  HWTou
//
//  Created by 彭鹏 on 2017/7/5.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonalInfoReq.h"
#import "RongduManager.h"
#import <HWTSDK/HWTAPI.h>
#import <YYModel/YYModel.h>
#import "PersonalInfoDM.h"
#import "AccountManager.h"
#import "PublicHeader.h"
#import "RDInfoReq.h"

@interface RDUserModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, assign) NSInteger userId;

@end

@implementation RDUserModel

@end

@interface RongduManager () <HWTAPIDelegate>

@end

@implementation RongduManager

+ (instancetype)share
{
    static id instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)initRongduSDK
{
    [HWTAPI sharedInstance].delegate = self;
    if ([AccountManager isNeedLogin] == NO) {
        [self autoLogin];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(investResultNotify:) name:@"InvestResult" object:nil];
}

- (void)investResultNotify:(NSNotification *)notify
{
    NSLog(@"收到融都SDK通知，购买产品成功");
    [self investRecordWithPage:1];
}

- (void)didFinishLoginOrRegisterWithUserInfo:(NSDictionary *)data ActionType:(actionType)actionType
{
    NSLog(@"%@", data);
    NSString *error = [data objectForKey:@"error"];
    if (error.length > 0) {
        NSLog(@"didFinishLoginOrRegisterWithUserInfo error: %@", error);
        return;
    }
    RDUserInfoParam *userInfo = [RDUserInfoParam yy_modelWithDictionary:data];
    userInfo.userName = userInfo.phoneNumber; // 为了统一: 安卓用的是userName,iOS是手机号
    [RDInfoReq updateWithParam:userInfo success:^(BaseResponse *response) {
        if (!response.success) {
            [self logout];
            [HUDProgressTool showOnlyText:response.msg];
        }
    } failure:^(NSError *error) {
        [self logout];
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];

}

- (void)getInvestRecordList:(NSDictionary *)data
{
    NSLog(@"%@", data);
}

- (void)getInvestList
{
    [RDInfoReq listWithSuccess:^(RDInvestListResp *response) {
        if (response.success) {
            NSMutableArray *list = [NSMutableArray arrayWithCapacity:response.data.count];
            [response.data enumerateObjectsUsingBlock:^(RDInvestListDM *obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:obj.id forKey:@"ID"];
                [dict setObject:obj.rate forKey:@"apr"];
                [dict setObject:@"YES" forKey:@"isShow"];
                
                [list addObject:dict];
            }];
            if (list.count > 0) {
                [[HWTAPI sharedInstance] initProductListDataWithDataArray:list];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)unbindAccount
{
    // 1. 判断有没有绑定过账号
    [HUDProgressTool showIndicatorWithText:nil];
    
    [PersonalInfoReq personalInfoSuccess:^(PersonalInfoResp *response) {
        
        [HUDProgressTool dismiss];
        if (response.data.is_bang) {
            [self handleUnbindAccount:response.data];
        } else {
            [[UIApplication topViewController].navigationController popViewControllerAnimated:YES];
            // 3. 解绑成功，退出融都登录
            [[HWTAPI sharedInstance] userLogout:nil FromVC:nil];
            //[HUDProgressTool showOnlyText:@"当前没有绑定铜钱账号，不需要解绑"];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
    }];
}

- (void)handleUnbindAccount:(PersonalInfoDM *)dmInfo
{
    NSString *message = [NSString stringWithFormat:@"登录的账号:%@\n确定退出登录吗？", dmInfo.phoneNumber];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [HUDProgressTool showIndicatorWithText:nil];
        // 2. 调用后台接口解绑
        RDUnbindParam *param = [RDUnbindParam new];
        param.r_username = dmInfo.phoneNumber;
        param.r_password = dmInfo.pwd;
        
        [RDInfoReq unbindWithParam:param success:^(BaseResponse *response) {
            // [HUDProgressTool showOnlyText:@"铜钱账号解绑成功"];
            [HUDProgressTool dismiss];
            [[UIApplication topViewController].navigationController popViewControllerAnimated:YES];
            // 3. 解绑成功，退出融都登录
            [[HWTAPI sharedInstance] userLogout:nil FromVC:nil];
        } failure:^(NSError *error) {
            [HUDProgressTool showOnlyText:[error urlErrorCodeDescribe]];
        }];
    }];
    
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionNO];
    [alert addAction:actionYES];
    [[UIApplication topViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)getInvestRecord
{
    NSDictionary *userInfo = [[HWTAPI sharedInstance] getUserInfo];
    NSString *error = [userInfo objectForKey:@"error"];
    if (error.length > 0) {
        NSLog(@"getInvestRecord error: %@", error);
        return;
    }
    [self investRecordWithPage:1];
}

- (NSInteger)getRdUserId
{
    NSDictionary *userInfo = [[HWTAPI sharedInstance] getUserInfo];
    RDUserInfoParam *dmInfo = [RDUserInfoParam yy_modelWithDictionary:userInfo];
    return dmInfo.userId;
}

- (void)investRecordWithPage:(NSUInteger)page
{
    [[HWTAPI sharedInstance] getUserTenderLogListWithPageNumber:page result:^(NSDictionary *dataDic, RdAppError *error) {
        if (dataDic == nil) {
            NSLog(@"%@", error.errMessage);
            return;
        }
        
        NSInteger pageTotal = [[dataDic objectForKey:@"page_total"] integerValue];
        NSArray *investList = [dataDic objectForKey:@"investList"];
        if (investList.count > 0) {
            NSMutableArray *records = [NSMutableArray arrayWithCapacity:investList.count];
            for (NSDictionary *dictInvest in investList) {
                RDInvestRecordDM *dmRecord = [RDInvestRecordDM yy_modelWithDictionary:dictInvest];
                [records addObject:dmRecord];
            }
            
            RDInvestRecordParam *param = [[RDInvestRecordParam alloc] init];
            param.investList = records;
            [RDInfoReq recordWithParam:param success:^(BaseResponse *response) {
                if (response.success) {
                    if (page < pageTotal) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self investRecordWithPage:page+1];
                        });
                    }
                }
            } failure:nil];
        }
    }];
}

- (void)autoLogin
{
    [PersonalInfoReq personalInfoSuccess:^(PersonalInfoResp *response) {
        if (response.data.is_bang) {
            [[HWTAPI sharedInstance] initHWTParamsWithPhone:response.data.phoneNumber
                                                    withPwd:response.data.pwd
                                                withAappKey:nil
                                              withAppSecret:nil
                                        useProductionServer:YES];
            
            [[HWTAPI sharedInstance] autoLoginActionFrom:nil
                                                  result:^(BOOL isOK) {
                NSLog(@"融都自动登录%@", isOK ? @"成功": @"失败");
            }];
        } else {
            [[HWTAPI sharedInstance] userLogout:nil FromVC:nil];
        }
    } failure:nil];
}

- (void)logout
{
    [[HWTAPI sharedInstance] userLogout:nil FromVC:nil];
}

@end

