//
//  NTESSessionHistoryConfig.h
//  NIM
//
//  Created by emily on 30/01/2018.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NIMSessionConfig;
@interface NTESSessionHistoryConfig : NSObject<NIMSessionConfig>

@property(nonatomic, strong) NIMSession *session;

- (instancetype)initWithSession:(NIMSession *)session andFirstMsg:(NIMMessage *)msg;

@end
