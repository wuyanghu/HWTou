//
//  GetQuestionBankInfoModel.h
//  HWTou
//
//  Created by robinson on 2018/2/1.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetQuestionBankInfoModel : BaseModel
@property (nonatomic,assign) NSInteger quesId;// 题目ID
@property (nonatomic,copy) NSString * quesTitle;//题目标题
@property (nonatomic,copy) NSString * quesDesc ;//题目描述
@property (nonatomic,copy) NSString * voiceIntroduce ;// 题目语音url
@property (nonatomic,strong) NSMutableArray *quesOptionArr;// 题目选项集合
@end

@interface QuesOptionsModel :BaseModel
@property (nonatomic,copy) NSString * k;// 选项
@property (nonatomic,copy) NSString * v;//答案
@end


