//
//  CourseModel.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CourseModel.h"

@implementation CourseModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"addresses" : [CoursesAddressModel class]};
    
}

@end
