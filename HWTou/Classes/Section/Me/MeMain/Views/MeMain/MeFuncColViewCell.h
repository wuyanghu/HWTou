//
//  MeFuncColViewCell.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeFuncModel.h"

#define kMeFuncColCellId        (@"FuncColCellId")

@interface MeFuncColViewCell : UICollectionViewCell

- (void)setPackageCellUpDataSource:(MeFuncModel *)model
             cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
