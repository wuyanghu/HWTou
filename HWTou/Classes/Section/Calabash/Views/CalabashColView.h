//
//  CalabashColView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CalabashColType){
    
    CalabashColType_Unknown = 0,
    CalabashColType_NewCourse,       // 最新课程
    CalabashColType_AllCourse,       // 所有课程
    CalabashColType_Teachers,        // 教师
    
};

@protocol CalabashColViewDelegate <NSObject>

- (void)onSelCalabashColViewWithColType:(CalabashColType)colType withDataSource:(NSObject *)object;

@end

@interface CalabashColView : UIView

@property (nonatomic, weak) id<CalabashColViewDelegate> m_Delegate;

- (void)setCalabashColViewType:(CalabashColType)colType;

- (void)setCalabashColViewType:(CalabashColType)colType withSearchKey:(NSString *)key;

@end
