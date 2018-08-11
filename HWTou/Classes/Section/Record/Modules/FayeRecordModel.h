//
//  FayeRecordModel.h
//  HWTou
//
//  Created by Reyna on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonMacro.h"

@interface FayeRecordModel : NSObject

@property (nonatomic,copy) NSString *path;

@property (nonatomic,strong) NSArray *levels; // 振幅数组

@property (nonatomic,assign) NSInteger duration;

SingletonH();

@end
