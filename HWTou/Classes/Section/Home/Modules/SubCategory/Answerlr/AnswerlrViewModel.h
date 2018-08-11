//
//  AnswerlrViewModel.h
//  HWTou
//
//  Created by robinson on 2018/1/31.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "GetActivityModel.h"
#import "GetUserInfoModel.h"
#import "GetSpecListModel.h"
#import "GetQuestionBankInfoModel.h"
#import "GetWinUserModel.h"

#define COUNTDOWN 180 //开始倒计时

//活动页面
@protocol AnswerlrViewModelDelegate
- (void)nextView;
- (void)pushCountdownViewController;//进入倒计时
- (void)lookView;//只能围观
- (void)activityFinish;//活动结束
- (void)pushProcessViewController;//答题开始
@end

//倒计时页面
@protocol CountDownDeleagete
- (void)countdownView:(NSString *)time;//倒计时
- (void)updateOnlineNum;//更新在线人数
@end

//答题页面
@protocol ProcessDelegate
- (void)showTopic:(NSInteger)rank;//展示题目
- (void)showResult;//题目展示结果
- (void)popView;//弹出页面
- (void)countDownTime:(NSInteger)count;//倒计时
- (void)answerResult;//答题结果
- (void)updateOnlineNum;//更新在线人数
@end

@interface AnswerlrViewModel : BaseViewModel

@property (nonatomic,weak) id<AnswerlrViewModelDelegate> answerlrDeleate;
@property (nonatomic,weak) id<CountDownDeleagete> downDelegate;
@property (nonatomic,weak) id<ProcessDelegate> processDelegate;

@property (nonatomic,strong) GetActivityModel * activityModel;
@property (nonatomic,strong) GetUserInfoModel * userInfoModel;
@property (nonatomic,strong) GetQuestionBankInfoModel * questionBankInfoModel;
@property (nonatomic,strong) GetWinUserModel * winUserModel;
@property (nonatomic,strong) NSMutableArray<GetSpecListModel *> * specListArr;
@property (nonatomic,assign) NSInteger serverTimeDouble;//服务时间
@property (nonatomic,assign) double startTime;//活动时间
//@property (nonatomic,assign) NSInteger selectSpecId;//选中的专场id
@property (nonatomic,strong) GetSpecListModel * selectSpecModel;//选中的专场id
@property (nonatomic,assign) BOOL isContinueAnswer;

+ (instancetype)sharedInstance;
- (void)bindGetWinUserModel:(NSDictionary *)dict;
- (void)bindGetActivityModel:(NSDictionary *)dict;
- (void)bindGetUserInfoModel:(NSDictionary *)dict;
- (void)bindServerTime:(NSString *)date;
- (void)bindGetSpecList:(NSArray *)array;
- (void)bindGetQuestionBankInfoModel:(NSDictionary *)dict;
- (void)stopTime;
- (void)keepTime;
//判断是否是倒计时
- (BOOL)isDownTime;

- (void)updateProcessView;//重新进入时，直接更新题目信息
- (NSString *)getDayString;//判断昨天今天、明天、昨天

- (NSInteger)calculateAnswerNum;//计算第几题
- (void)destroyVar;//销毁变量
@end
