//
//  NSURL+Parameters.h
//  HWTou
//
//  Created by 彭鹏 on 2017/7/17.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Parameters)

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getParameters;

@end
