//
//  AppConfigMacro.h
//
//  Created by 彭鹏 on 16/9/10.
//  Copyright © 2016年 PP. All rights reserved.
//

#ifndef AppConfigMacro_h
#define AppConfigMacro_h
#import "UtilsMacro.h"

#pragma mark - 输入框字体大小,颜色
/**************************************************************/

// app主题颜色(0x466e8c)
#define AppThemeColor               [UIColor colorWithRed:0.275 green:0.431 blue:0.549 alpha:1]

// 字体大小缩放
#define FontSizeScale(size)         size //((kMainScreenWidth / 375) * size)
// 坐标大小缩放
#define CoordXSizeScale(size)       ((kMainScreenWidth / 375) * size)
#define CoordYSizeScale(size)       ((kMainScreenHeight / 667) * size)

// 苹方字体
#define FontPFThin(fSize)            [UIFont fontWithName:@"PingFangSC-Thin" size:FontSizeScale(fSize)] ?: [UIFont systemFontOfSize:fSize]
#define FontPFLight(fSize)           [UIFont fontWithName:@"PingFangSC-Light" size:FontSizeScale(fSize)] ?: [UIFont systemFontOfSize:fSize]
#define FontPFMedium(fSize)          [UIFont fontWithName:@"PingFangSC-Medium" size:FontSizeScale(fSize)] ?: [UIFont systemFontOfSize:fSize]
#define FontPFRegular(fSize)         [UIFont fontWithName:@"PingFangSC-Regular" size:FontSizeScale(fSize)] ?: [UIFont systemFontOfSize:fSize]

#define SYSTEM_FONT(SIZE)            [UIFont systemFontOfSize:SIZE]

#endif
