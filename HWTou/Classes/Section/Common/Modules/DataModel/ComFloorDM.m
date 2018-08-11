//
//  ComFloorDM.m
//  HWTou
//
//  Created by pengpeng on 17/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ComFloorDM.h"

@implementation FloorItemDM

@end

@implementation FloorDataDM

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"floorItems" : [FloorItemDM class]};
}

@end

@implementation FloorInfoDM

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"floor_data" : [FloorDataDM class]};
}

@end

@implementation FloorListDM

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"floor_info" : [FloorInfoDM class]};
}

@end
