//
//  AnswerlrViewModel.m
//  HWTou
//
//  Created by robinson on 2018/1/31.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AnswerlrViewModel.h"
#import "PublicHeader.h"
#import "AnswerLsRequest.h"

@interface AnswerlrViewModel()
{
    dispatch_source_t _timer;
    BOOL isStartAnswer;
}
@property (nonatomic,strong) NSDateFormatter * dateFormat;
@end

@implementation AnswerlrViewModel

#pragma mark - 初始化

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hadEnterBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];//进后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hadEnterForegroundGround) name:UIApplicationWillEnterForegroundNotification object:nil];//进前台
    }
    return self;
}

+ (instancetype)sharedInstance {
    static AnswerlrViewModel *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - home控制
- (void)hadEnterBackGround{
    NSLog(@"进后台");
    [self pauseTimer];
}

- (void)hadEnterForegroundGround{
    NSLog(@"进前台");
    [self resumeTimer];
    [self updateServeDate];
}

#pragma mark - 更新时间
//前台进入后台
- (void)stopServeDate{
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

//后台进前台时更新服务时间
- (void)updateServeDate{
    if (_timer) {
        [self keepTime];
        NSLog(@"更新服务时间");
        [AnswerLsRequest getDate:nil Success:^(AnswerLsDate *response) {
            if (response.status == 200) {
                NSInteger nowServeDataInter = [response.data doubleValue]/1000;//服务器最新时间
                //答题开始了，如果退出的时间大于题目展示的时间,只能围观
                if (isStartAnswer && nowServeDataInter-_serverTimeDouble>_activityModel.quesStay) {
                    NSLog(@"只能围观了");
                    _isContinueAnswer = NO;
                }
                [self bindServerTime:response.data];
                [self updateProcessView];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
//重新进入时，直接更新题目信息
- (void)updateProcessView{
    NSInteger interval = _serverTimeDouble-_startTime;
    NSInteger eachTopicDuration = _activityModel.quesStay+_activityModel.ansStay;
    if (interval<0) {
        NSInteger squInterVal = -(NSInteger)interval;
        NSLog(@"距离开始还有:%ld",squInterVal);
        if (squInterVal < COUNTDOWN) {//跳转到倒计时
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_answerlrDeleate) {
                    [_answerlrDeleate pushCountdownViewController];
                }
            });
        }
    }else if (interval>=0 && interval<eachTopicDuration*_activityModel.quesNum) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_answerlrDeleate) {
                [_answerlrDeleate pushProcessViewController];
            }
        });
        
        //答题
        if (eachTopicDuration == 0) {
            return;
        }
        NSInteger theNum = interval/eachTopicDuration;//题目
        NSInteger mod = interval%eachTopicDuration;//取余
        
        if (mod<_activityModel.quesStay) {
            NSLog(@"第%ld题,展示题目",theNum+1);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_processDelegate) {
                    [_processDelegate showTopic:theNum];
                }
            });
            
        }else if (mod < (_activityModel.quesStay+_activityModel.ansStay)){
            NSLog(@"第%ld题,展示答案",theNum+1);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_processDelegate) {
                    [_processDelegate showResult];
                }
            });
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_processDelegate) {
                [_processDelegate popView];
            }
        });
    }
}

#pragma mark - 页面处理逻辑

- (void)viewLogic{
    double interval = _serverTimeDouble- _startTime;
    if (interval<0) {//活动未开始
        isStartAnswer = NO;
        _isContinueAnswer = YES;
        
        NSInteger squInterVal = -(NSInteger)interval;
        NSLog(@"距离开始还有:%ld",squInterVal);
        if (squInterVal>COUNTDOWN) {//活动未开始
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_answerlrDeleate) {
                    [_answerlrDeleate nextView];
                }
            });
        }else if (squInterVal == COUNTDOWN) {//自动跳转到倒计时
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_answerlrDeleate) {
                    [_answerlrDeleate pushCountdownViewController];
                }
            });
        }else if (squInterVal<COUNTDOWN) {//
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_answerlrDeleate) {
                    [_answerlrDeleate lookView];
                }
                
                if (_downDelegate) {
                    [_downDelegate countdownView:[self getCountDownTime:squInterVal]];
                }
            });
        }else{
            
        }
        
    }else if (interval == 0){//答题开始
        isStartAnswer = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_answerlrDeleate) {
                [_answerlrDeleate pushProcessViewController];
            }

        });
        
    }else{//答题进行中或结束
        isStartAnswer = YES;
        
        NSInteger totalDuration = (_activityModel.quesStay+_activityModel.ansStay)*_activityModel.quesNum;
        if (interval<totalDuration) {
//            NSLog(@"活动正在进行...");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_answerlrDeleate) {
                    [_answerlrDeleate lookView];
                }
            });
        }else if(interval >= (totalDuration+2)){//延迟2s刷新
//            NSLog(@"活动结束");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_answerlrDeleate) {
                    [_answerlrDeleate activityFinish];
                }
            });
        }
    }
}

//计算答题时间
- (void)calculateAnswerTime{
    NSInteger interval = _serverTimeDouble-_startTime;
    NSInteger eachTopicDuration = _activityModel.quesStay+_activityModel.ansStay;
    if (interval>=0 && interval<eachTopicDuration*_activityModel.quesNum) {
        //答题
        if (eachTopicDuration == 0) {
            return;
        }
        NSInteger theNum = interval/eachTopicDuration;//题目
        NSInteger mod = interval%eachTopicDuration;//取余
        if (mod>=0 && mod<_activityModel.quesStay) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_processDelegate) {
                    [_processDelegate countDownTime:_activityModel.quesStay-mod];
                }
            });
        }
        
        if (mod == 0) {
            NSLog(@"第%ld题,展示题目",theNum+1);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_processDelegate) {
                    [_processDelegate showTopic:theNum];
                }
            });
            
        }else if (mod ==  _activityModel.quesStay){
            NSLog(@"第%ld题,展示答案",theNum+1);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_processDelegate) {
                    [_processDelegate showResult];
                }
            });
        }
    }else if (interval == eachTopicDuration*_activityModel.quesNum){//展示结果
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_processDelegate) {
                [_processDelegate answerResult];
            }
        });
    }
}
//更新在线人数
- (void)updateOnlineNum{
    NSInteger interval = _serverTimeDouble- _startTime;
    if (interval<0) {//活动未开始
        
        NSInteger squInterVal = -(NSInteger)interval;
        if (squInterVal<=COUNTDOWN) {//
            if (squInterVal%5==0) {
                if (_downDelegate) {
                    [_downDelegate updateOnlineNum];
                }
            }
            
        }else{
            
        }
        
    }else{
        
        NSInteger totalDuration = (_activityModel.quesStay+_activityModel.ansStay)*_activityModel.quesNum;
        if (interval<totalDuration) {
            if (interval%5==0) {
                if (_processDelegate) {
                    [_processDelegate updateOnlineNum];
                }
            }
        }
    }
}

//判断是否是倒计时
- (BOOL)isDownTime{
    NSInteger interval = _serverTimeDouble-_startTime;
    if (interval<0) {
        return YES;
    }
    return NO;
}

//计算第几题
- (NSInteger)calculateAnswerNum{
    NSInteger interval = _serverTimeDouble-_startTime;
    NSInteger eachTopicDuration = _activityModel.quesStay+_activityModel.ansStay;
    if (interval>=0 && interval<=eachTopicDuration*_activityModel.quesNum) {
        NSInteger theNum = interval/eachTopicDuration;//题目
        return theNum;
    }
    return -1;
}

#pragma mark - timer

- (void)keepTime{
    WeakObj(self);
    
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        _serverTimeDouble = _serverTimeDouble+1;

        [selfWeak viewLogic];
        [selfWeak calculateAnswerTime];
        [selfWeak updateOnlineNum];
    });
    dispatch_resume(_timer);
}

- (void)stopTime{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

-(void)pauseTimer{
    if(_timer){
        dispatch_suspend(_timer);
    }
}
-(void)resumeTimer{
    if(_timer){
        dispatch_resume(_timer);
    }
}

#pragma mark - 时间处理

- (NSString *)getCountDownTime:(NSInteger)squInterVal{
    NSInteger minute = squInterVal/60;
    NSInteger second = squInterVal%60;
    
    NSString * minuteStr;
    if (minute<10) {
        minuteStr = [NSString stringWithFormat:@"0%ld",minute];
    }else{
        minuteStr = [NSString stringWithFormat:@"%ld",minute];
    }
    
    NSString * secondStr;
    if (second<10) {
        secondStr = [NSString stringWithFormat:@"0%ld",second];
    }else{
        secondStr = [NSString stringWithFormat:@"%ld",second];
    }
    
    NSString * countDownTime = [NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];
    
    return countDownTime;
}

//判断昨天今天、明天、昨天
- (NSString *)getDayString{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    [self.dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * todayDate = [NSDate dateWithTimeIntervalSince1970:_serverTimeDouble+8*60*60];
    NSDate * tomorrowDate = [todayDate dateByAddingTimeInterval: secondsPerDay];
    NSDate * yesterdayDate = [todayDate dateByAddingTimeInterval: -secondsPerDay];
    
    NSString * todayString = [[todayDate description] substringToIndex:10];
    NSString * tomorrowSting = [[tomorrowDate description] substringToIndex:10];
    NSString * yesterdayString = [[yesterdayDate description] substringToIndex:10];
    
    NSDate * servedate = [self.dateFormat dateFromString:self.activityModel.startTime];//活动时间
    NSString * servedateString = [[servedate description] substringToIndex:10];

    NSLog(@"服务时间 %@,活动时间 %@",[todayDate description],self.activityModel.startTime);
    
    [self.dateFormat setDateFormat:@"HH:mm"];
    NSString * publishtimeStr = [self.dateFormat stringFromDate:servedate];
    
    if ([servedateString isEqualToString:todayString]) {
        return [NSString stringWithFormat:@"今天%@",publishtimeStr];
    }else if ([servedateString isEqualToString:tomorrowSting]){
        return [NSString stringWithFormat:@"明天%@",publishtimeStr];
    }else if ([servedateString isEqualToString:yesterdayString]){
        return [NSString stringWithFormat:@"昨天%@",publishtimeStr];
    }else{
        if (servedateString == nil) {
            return @"00:00";
        }
        return servedateString;
    }
}

#pragma mark - 绑定数据

- (void)bindGetWinUserModel:(NSDictionary *)dict{
    [self.winUserModel setValuesForKeysWithDictionary:dict];
    [self.winUserModel.userResultModelArr removeAllObjects];
    NSArray * userDatasArr = dict[@"userDatas"];
    for (NSDictionary * userDict in userDatasArr) {
        GetWinUserResultModel * resultModel = [GetWinUserResultModel new];
        [resultModel setValuesForKeysWithDictionary:userDict];
        
        [self.winUserModel.userResultModelArr addObject:resultModel];
    }
}

- (void)bindGetActivityModel:(NSDictionary *)dict{

    if (dict) {
        [self.activityModel setValuesForKeysWithDictionary:dict[@"activity"]];
    }else{
        _activityModel = nil;
    }
    
    self.activityModel.quesNum = [dict[@"quesNum"] integerValue];
    
    _startTime = self.activityModel.timestamp/1000;
}

- (void)bindGetUserInfoModel:(NSDictionary *)dict{
    [self.userInfoModel setValuesForKeysWithDictionary:dict];
}

- (void)bindServerTime:(NSString *)date{
    _serverTimeDouble = [date doubleValue]/1000;
}

- (void)bindGetSpecList:(NSArray *)array{
    [self.specListArr removeAllObjects];
    
    for (NSDictionary * dict in array) {
        GetSpecListModel * specModel = [GetSpecListModel new];
        [specModel setValuesForKeysWithDictionary:dict];
        specModel.specId = [dict[@"id"] integerValue];
        
        [self.specListArr addObject:specModel];
    }
}

- (void)bindGetQuestionBankInfoModel:(NSDictionary *)dict{
    [self.questionBankInfoModel setValuesForKeysWithDictionary:dict];
    [self.questionBankInfoModel.quesOptionArr removeAllObjects];
    
    NSArray * arr =  dict[@"quesOptions"];
    for (NSDictionary * optdict in arr) {
        QuesOptionsModel * optionModel = [QuesOptionsModel new];
        [optionModel setValuesForKeysWithDictionary:optdict];
        
        [self.questionBankInfoModel.quesOptionArr addObject:optionModel];
    }
}

#pragma mark - 销毁变量

- (void)destroyVar{
    _winUserModel = nil;
    _questionBankInfoModel = nil;
}

#pragma mark - getter

- (GetSpecListModel *)selectSpecModel{
    if (!_selectSpecModel) {
        _selectSpecModel = [GetSpecListModel new];
    }
    return _selectSpecModel;
}

- (GetWinUserModel *)winUserModel{
    if (!_winUserModel) {
        _winUserModel = [GetWinUserModel new];
    }
    return _winUserModel;
}

- (GetQuestionBankInfoModel *)questionBankInfoModel{
    if (!_questionBankInfoModel) {
        _questionBankInfoModel = [GetQuestionBankInfoModel new];
    }
    return _questionBankInfoModel;
}

- (GetUserInfoModel *)userInfoModel{
    if (!_userInfoModel) {
        _userInfoModel = [GetUserInfoModel new];
    }
    return _userInfoModel;
}

- (GetActivityModel *)activityModel{
    if (!_activityModel) {
        _activityModel = [GetActivityModel new];
    }
    return _activityModel;
}

- (NSDateFormatter *)dateFormat{
    if (!_dateFormat) {
        _dateFormat = [[NSDateFormatter alloc] init];
        [_dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    }
    return _dateFormat;
}

- (NSMutableArray<GetSpecListModel *> *)specListArr{
    if (!_specListArr) {
        _specListArr = [NSMutableArray array];
    }
    return _specListArr;
}
@end
