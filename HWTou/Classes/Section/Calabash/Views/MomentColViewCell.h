//
//  MomentColViewCell.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/4.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MomentModel.h"

#define kMomentColViewCellId       (@"MomentColViewCellId")

@interface MomentColViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) MomentModel *m_Model;

- (void)setMomentColViewCellUpDataSource:(MomentModel *)model
                   cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
