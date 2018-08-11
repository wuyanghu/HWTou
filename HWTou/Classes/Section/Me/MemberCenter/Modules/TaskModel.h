//
//  TaskModel.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TaskType){
    
    TaskType_Investment = 0,        // 投资
    TaskType_Shopping,              // 购物
    TaskType_Evaluation,            // 评价
    TaskType_Activity,              // 参加活动
    TaskType_EvaluationActivity,    // 评价活动
    
};

@interface TaskModel : NSObject

@property (nonatomic, assign) TaskType m_TaskType;
@property (nonatomic, strong) NSString *m_Title;
@property (nonatomic, strong) NSString *m_Remark;
@property (nonatomic, strong) NSString *m_ImgName;

@end
