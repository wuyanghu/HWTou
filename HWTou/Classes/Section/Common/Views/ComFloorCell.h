//
//  ComFloorCell.h
//  HWTou
//
//  Created by pengpeng on 17/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FloorDataDM;

// 单图楼层
@interface ComFloorCell : UICollectionViewCell

@property (nonatomic, copy) NSArray<FloorDataDM *> *floorData;

@end

// 单图楼层
@interface FloorOneCell : ComFloorCell

@end

// 双图楼层
@interface FloorTwoCell : ComFloorCell

@end

