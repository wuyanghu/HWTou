//
//  CourseColViewCell.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/31.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CourseModel.h"

#define kCourseColViewCellId       (@"CourseColCellId")

@protocol CourseColViewCellDelegate <NSObject>



@end

@interface CourseColViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) CourseModel *m_Model;
@property (nonatomic, weak) id<CourseColViewCellDelegate> m_Delegate;

- (void)setCourseColCellUpDataSource:(CourseModel *)model
               cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
