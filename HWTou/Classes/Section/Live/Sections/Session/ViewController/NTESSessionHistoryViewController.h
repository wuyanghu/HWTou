//
//  NTESSessionHistoryViewController.h
//  NIM
//
//  Created by emily on 30/01/2018.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "NIMSessionViewController.h"

@interface NTESSessionHistoryViewController : NIMSessionViewController

@property (nonatomic,assign) BOOL disableCommandTyping;  //需要在导航条上显示“正在输入”

- (instancetype)initWithSession:(NIMSession *)session andSearchMsg:(NIMMessage *)msg;

@end
