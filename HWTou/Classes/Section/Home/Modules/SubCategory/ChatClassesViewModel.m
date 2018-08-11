//
//  ChatClassesViewModel.m
//  HWTou
//
//  Created by robinson on 2018/1/3.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ChatClassesViewModel.h"
#import "PublicHeader.h"

@implementation ChatClassesViewModel

- (void)bindWithChatClassesModel:(NSArray *)array{
    [self.chatClassesModelArr removeAllObjects];
    [self.otherChatClassSecsArr removeAllObjects];
    
    for (int i = 0;i<array.count;i++) {
        NSArray * dataArr = array[i];
        
        NSMutableArray * resultArr = [NSMutableArray array];
        for (NSDictionary * dict in dataArr) {
            
            ChatClassesModel * classesModel = [ChatClassesModel new];
            [classesModel setValuesForKeysWithDictionary:dict];
            
            NSArray * secsArr = dict[@"chatClassSecs"];
            for (NSDictionary * secsDict in secsArr) {
                ChatClassSecsModel * secsModel = [ChatClassSecsModel new];
                [secsModel setValuesForKeysWithDictionary:secsDict];
                
                [classesModel.chatClassSecsArr addObject:secsModel];
            }
            [resultArr addObject:classesModel];
        }
        if (i == 0) {
            [self.chatClassesModelArr addObjectsFromArray:resultArr];
        }else{
            [self.otherChatClassSecsArr addObjectsFromArray:resultArr];
        }
    }
    
    
    
    
    for (int i = 0; i<self.chatClassesModelArr.count; i++) {
        ChatClassesModel * classesModel = self.chatClassesModelArr[i];
        classesModel.isShowAll = YES;
        [classesModel.showArr removeAllObjects];
        
        if (classesModel.chatClassSecsArr.count<=6) {
            [classesModel.showArr addObjectsFromArray:classesModel.chatClassSecsArr];
        }else{
            for (int i = 0; i<5; i++) {
                ChatClassSecsModel * secsModel = classesModel.chatClassSecsArr[i];
                [classesModel.showArr addObject:secsModel];
            }
            ChatClassSecsModel * arrawModel = [ChatClassSecsModel new];
            arrawModel.classIdSec = -1;
            [classesModel.showArr addObject:arrawModel];
        }
    }
}

- (void)showArrowData:(ChatClassesModel * )chatModel{
    for (int i = 0; i<self.chatClassesModelArr.count; i++) {
        ChatClassesModel * classesModel = self.chatClassesModelArr[i];
        if (chatModel.classId == classesModel.classId) {
            [classesModel.showArr removeAllObjects];
            
            if (classesModel.isShowAll) {
                [classesModel.showArr addObjectsFromArray:classesModel.chatClassSecsArr];
                ChatClassSecsModel * arrawModel = [ChatClassSecsModel new];
                arrawModel.classIdSec = -1;
                [classesModel.showArr addObject:arrawModel];
                
                classesModel.isShowAll = NO;
            }else{
                for (int i = 0; i<5; i++) {
                    ChatClassSecsModel * secsModel = classesModel.chatClassSecsArr[i];
                    [classesModel.showArr addObject:secsModel];
                }
                ChatClassSecsModel * arrawModel = [ChatClassSecsModel new];
                arrawModel.classIdSec = -1;
                [classesModel.showArr addObject:arrawModel];
                
                classesModel.isShowAll = YES;
            }
            
            break;
        }
        
    }
}

- (NSInteger)getSection{
    return self.chatClassesModelArr.count;
}

- (CGSize)calcuateCellSize:(NSIndexPath *)indexPath{
    ChatClassesModel * classModel = self.chatClassesModelArr[indexPath.section];
    if (classModel.showArr.count<=6) {
        return CGSizeMake(kMainScreenWidth, 95);
    }
    NSInteger cellRow = classModel.showArr.count/3+1;//cell多少行
    CGFloat sizeHeight = cellRow*50-5;
    return CGSizeMake(kMainScreenWidth, sizeHeight);
}

#pragma mark - getter

- (NSMutableArray<ChatClassesModel *> *)otherChatClassSecsArr{
    if (!_otherChatClassSecsArr) {
        _otherChatClassSecsArr = [NSMutableArray array];
    }
    return _otherChatClassSecsArr;
}

- (NSMutableArray<ChatClassesModel *> *)chatClassesModelArr{
    if (!_chatClassesModelArr) {
        _chatClassesModelArr = [NSMutableArray array];
    }
    return _chatClassesModelArr;
}

@end
