//
//  ChatClassesModel.m
//  HWTou
//
//  Created by robinson on 2018/1/3.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ChatClassesModel.h"

@implementation ChatClassSecsModel

@end

@implementation ChatClassesModel

- (NSMutableArray<ChatClassSecsModel *> *)chatClassSecsArr{
    if (!_chatClassSecsArr) {
        _chatClassSecsArr = [NSMutableArray array];
    }
    return _chatClassSecsArr;
}

- (NSMutableArray<ChatClassSecsModel *> *)showArr{
    if (!_showArr) {
        _showArr = [NSMutableArray array];
    }
    return _showArr;
}

@end
