//
//  CoursesEnrolmentSuccessViewController.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

#import "CourseModel.h"

@interface CoursesEnrolmentSuccessViewController : BaseViewController

- (void)setEnrolmentSuccessViewControllerDataSource:(CourseModel *)courseModel
                                    withAddressInfo:(CoursesAddressModel *)coursesAddressModel;

- (void)setEnrolmentSuccessViewControllerDataSource:(CourseModel *)courseModel
                                     withEnlistInfo:(EnlistModel *)enlistModel;

@end
