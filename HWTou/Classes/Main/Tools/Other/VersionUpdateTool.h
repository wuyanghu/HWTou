//
//  VersionUpdateTool.h
//
//  Created by 彭鹏 on 2017/6/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^VersionCheckCompleted)(NSError *error, NSString *version);

@interface VersionUpdateTool : NSObject

/**
 当前版本是否隐藏赚铜钱
 */
@property (nonatomic, getter=isShowInvest) BOOL showInvest;

/**
 获取单例对象
 @return VersionUpdateTool实例
 */
+ (instancetype)shared;

/**
 检测应用更新
 */
- (void)checkUpdate:(VersionCheckCompleted)completed;

@end
