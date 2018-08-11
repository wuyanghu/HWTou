//
//  GetAnsNumModel.h
//  HWTou
//
//  Created by robinson on 2018/2/7.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger,ANSNUMTYPE) {
    ansAnumType,
    ansBnumType,
    ansCnumType,
};

@interface GetAnsNumModel : BaseModel
@property (nonatomic,assign) NSInteger ansANum;//选择A选项的人数
@property (nonatomic,assign) NSInteger ansBNum;// 选择B选项的人数
@property (nonatomic,assign) NSInteger ansCNum;//选择C选项的人数
@property (nonatomic,copy) NSString * rightAnswer;//正确选项 (如：A)

- (double)getPercentage:(ANSNUMTYPE)ansnumType;
@end
