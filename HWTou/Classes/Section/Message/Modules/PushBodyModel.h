//
//  PushBodyModel.h
//  LieMi
//
//  Created by 彭鹏 on 16/10/15.
//  Copyright © 2016年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, PushRemoteType)
{
    PushRemoteUnknown   = 0, // 未知类型
};

@interface PushContentModel : NSObject

@property (nonatomic, assign) PushRemoteType    type;
@property (nonatomic, strong) NSDictionary      *data;

@end

@interface PushBodyModel : NSObject

@property (nonatomic, strong) PushContentModel  *wrap;

@end
