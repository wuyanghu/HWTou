//
//  AnswerLsParam.h
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseParam.h"

@interface AnswerLsParam : BaseParam

@end

@interface GetQuestionBankInfoParam:BaseParam
@property (nonatomic,assign) NSInteger actId;//活动ID
@property (nonatomic,assign) NSInteger rank;//排序值（题号）
@end

@interface GetActivityParam:BaseParam
@property (nonatomic,assign) NSInteger specId;//专场ID;
@end

@interface GetAnsNumParam:BaseParam
@property (nonatomic,assign) NSInteger  quesId;//题目ID
@property (nonatomic,assign) NSInteger rank;//题号
@end

@interface AddUserAnsParam:BaseParam
@property (nonatomic,assign) NSInteger quesId;//题目ID
@property (nonatomic,copy) NSString * answer;//答案，例如：A
@end

@interface UpdateStatusParam:BaseParam
@property (nonatomic,assign) NSInteger actId;//活动ID
@property (nonatomic,assign) NSInteger specId;//专场ID
@end

@interface GetMoneyParam:BaseParam
@property (nonatomic,assign) NSInteger actId;//活动ID
@end
