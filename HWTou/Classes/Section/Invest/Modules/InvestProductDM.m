//
//  InvestProductDM.m
//  HWTou
//
//  Created by 彭鹏 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "InvestProductDM.h"

@implementation InvestProductDM

- (void)setAmountBorrow:(NSNumber *)amountBorrow
{
    _amountBorrow = amountBorrow;
    self.formatBorrow = [self seperateNumberByComma:amountBorrow.integerValue];
}

- (NSString *)seperateNumberByComma:(NSInteger)number
{
    //提取正数部分
    BOOL negative = number<0;
    NSInteger num = labs(number);
    NSString *numStr = [NSString stringWithFormat:@"%ld",num];
    
    
    //根据数据长度判断所需逗号个数
    NSInteger length = numStr.length;
    NSInteger count = numStr.length/3;
    
    //在适合的位置插入逗号
    for (int i=1; i<=count; i++) {
        NSInteger location = length - i*3;
        if (location <= 0) {
            break;
        }
        
        //插入逗号拆分数据
        numStr = [numStr stringByReplacingCharactersInRange:NSMakeRange(location, 0) withString:@","];
    }
    
    //别忘给负数加上符号
    if (negative) {
        numStr = [NSString stringWithFormat:@"-%@",numStr];
    }
    
    return numStr;
}

@end

@implementation InvestProductListResp

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"tenderList" : [InvestProductDM class]};
}

@end
