//
//  CoursesEnrolmentSuccessView.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CourseModel.h"

@interface CoursesEnrolmentSuccessView : UIView

- (void)setSuccessViewDataSource:(CourseModel *)courseModel
                 withAddressInfo:(CoursesAddressModel *)coursesAddressModel;

- (void)setSuccessViewDataSource:(CourseModel *)courseModel
                  withEnlistInfo:(EnlistModel *)enlistModel;

@end
