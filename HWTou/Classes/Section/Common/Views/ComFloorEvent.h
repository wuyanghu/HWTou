//
//  ComFloorEvent.h
//  HWTou
//
//  Created by 彭鹏 on 2017/5/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComFloorDM.h"

@interface ComFloorEvent : NSObject

/**
 * 处理楼层事件
 *
 * @param dmFloor 楼层数据
 */
+ (void)handleEventWithFloor:(FloorItemDM *)dmFloor;

@end
