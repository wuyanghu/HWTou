//
//  HeaderRollCollectionReusableView.h
//  HWTou
//
//  Created by robinson on 2017/11/30.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionViewCell.h"

@protocol HeaderRollCollectionCellDelegate
- (void)carouselviewDidSelectItemAtIndex:(NSInteger)index;
@end

@interface HeaderRollCollectionCell : BaseCollectionViewCell
@property (nonatomic,weak) id<HeaderRollCollectionCellDelegate> cellDelegate;
@property (nonatomic,strong) NSArray * dataArray;
@end

