//
//  HomeConfigDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/5/2.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ComFloorDM.h"

typedef NS_ENUM(NSInteger, HomePosition)
{
    HomePositionUnknow,
    HomePositionLeft,     // 左图
    HomePositionRightT,   // 右上
    HomePositionRightB,   // 右下
};

@interface HomeConfigDM : FloorItemDM

// 图片位置
@property (nonatomic, assign) HomePosition id;

@end
