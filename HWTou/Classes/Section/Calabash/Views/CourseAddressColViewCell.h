//
//  CourseAddressColViewCell.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoursesAddressModel.h"

#define kCourseAddressColViewCellId       (@"CourseAddressColViewCellId")

@interface CourseAddressColViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *m_SelectView;

@property (nonatomic, strong, readonly) CoursesAddressModel *m_Model;

- (void)setCourseAddressColViewCellUpDataSource:(CoursesAddressModel *)model
                          cellForRowAtIndexPath:(NSIndexPath *)indexPath
                                      withIsEnd:(BOOL)isEnd;

@end
