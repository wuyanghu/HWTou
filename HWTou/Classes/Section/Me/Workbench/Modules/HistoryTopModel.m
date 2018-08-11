//
//  HistoryTopModel.m
//  HWTou
//
//  Created by robinson on 2018/1/4.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "HistoryTopModel.h"

@implementation HistoryTopModel

- (BOOL)isEqual:(id)object{
    if (self == object) {//对象本身
        return YES;
    }
    
    if (![object isKindOfClass:[HistoryTopModel class]]) {//不是本类
        return NO;
    }
    
    return [self isEqualToLocModel:(HistoryTopModel *)object];//必须全部属性相同 但是在实际开发中关键属性相同就可以
}

-(BOOL)isEqualToLocModel:(HistoryTopModel *)model{
    if (!model) {
        return NO;
    }
    
//    BOOL haveEqualNames = (!self.comUrl && !model.comUrl) || [self.comUrl isEqualToString:model.comUrl];
    BOOL haveEqualComId = (self.comId == model.comId);
//    return haveEqualNames && haveEqualComId;
    return haveEqualComId;
}


- (NSUInteger)hash {
//    return [self.comUrl hash] ^ self.comId;
    return self.comId;
}
@end
