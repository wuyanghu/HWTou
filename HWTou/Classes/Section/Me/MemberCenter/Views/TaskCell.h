//
//  TaskCell.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TaskModel.h"

@protocol TaskCellDelegate <NSObject>

- (void)onSelTaskItem:(TaskModel *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TaskCell : UITableViewCell

@property (nonatomic, weak) id<TaskCellDelegate> m_Delegate;

@property (nonatomic, strong, readonly) TaskModel *m_TaskModel;

- (void)setTaskCellWithDataSource:(TaskModel *)model withIsEnd:(BOOL)isEnd
        withCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
