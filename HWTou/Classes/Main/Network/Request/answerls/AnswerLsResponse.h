//
//  AnswerLsResponse.h
//  HWTou
//
//  Created by robinson on 2018/1/30.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseResponse.h"

@interface AnswerLsResponse : BaseResponse

@end

@interface AnswerLsDict:BaseResponse
@property (nonatomic,strong) NSDictionary * data;
@end

@interface AnswerLsArray:BaseResponse
@property (nonatomic,strong) NSArray * data;
@end

@interface AnswerLsDate:BaseResponse
@property (nonatomic,copy) NSString * data;
@end

@interface AnswerLsInt:BaseResponse
@property (nonatomic,assign) NSInteger data;
@end

@interface AnswerLsDouble:BaseResponse
@property (nonatomic,assign) NSString * data;
@end
