//
//  CoursesEnrolmentView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/3.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CourseModel.h"

@protocol CoursesEnrolmentViewDelegate <NSObject>

- (void)onEnrolmentSuccess:(CourseModel *)courseModel
           withAddressInfo:(CoursesAddressModel *)coursesAddressModel;

@end

@interface CoursesEnrolmentView : UIView

@property (nonatomic, weak) id<CoursesEnrolmentViewDelegate> m_Delegate;

- (void)setCoursesEnrolmentViewDataSource:(CourseModel *)model;

@end
