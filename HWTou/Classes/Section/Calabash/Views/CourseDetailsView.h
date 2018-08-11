//
//  CourseDetailsView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CourseModel.h"

@protocol CourseDetailsViewDelegate <NSObject>

- (void)onCoursesEnrolment:(CourseModel *)model;
- (void)onCoursesEnrolmentInfo:(CourseModel *)model;

@end

@interface CourseDetailsView : UIView

@property (nonatomic, weak) id<CourseDetailsViewDelegate> m_Delegate;

- (void)setCourseDetailsViewDataSource:(CourseModel *)model;

@end
