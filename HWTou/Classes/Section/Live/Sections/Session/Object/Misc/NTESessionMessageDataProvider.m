//
//  NTESessionMessageDataProvider.m
//  NIM
//
//  Created by emily on 30/01/2018.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "NTESessionMessageDataProvider.h"

@interface NTESessionMessageDataProvider ()

@property(nonatomic, strong) NIMMessage *firstMsg;

@end

@implementation NTESessionMessageDataProvider

- (instancetype)initWithSession:(NIMSession *)session andFirstMsg:(NIMMessage *)msg {
    if (self = [super init]) {
        _session = session;
        _firstMsg = msg;
    }
    return self;
}

- (void)pullDown:(NIMMessage *)firstMessage handler:(NIMKitDataProvideHandler)handler {
    NIMMessageSearchOption *option = [NIMMessageSearchOption new];
    if (self.firstMsg) {
        option.endTime = self.firstMsg.timestamp;
    }
    if (firstMessage) {
        option.endTime = firstMessage.timestamp;
    }
    option.limit = [NIMKit sharedKit].config.messageLimit;
    option.allMessageTypes = YES;
    option.order = NIMMessageSearchOrderDesc;
    
    [[NIMSDK sharedSDK].conversationManager searchMessages:self.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        NSMutableArray *tmp = @[].mutableCopy;
        tmp = messages.mutableCopy;
        if (self.firstMsg) {
            [tmp addObject:self.firstMsg];
        }
        if (handler) {
            self.firstMsg = nil;
            handler(error, tmp);
        }
    }];
}

- (BOOL)needTimetag {
    return YES;
}

@end
