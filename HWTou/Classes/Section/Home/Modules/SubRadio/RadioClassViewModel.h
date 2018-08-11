//
//  RadioClassViewModel.h
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "RadioClassModel.h"

typedef NS_ENUM(NSInteger, RadioClassCellStyle) {
    RadioClassCellStyleHidden = 0, //隐藏
    RadioClassCellStyleShow   = 1, //显示全部
};

@interface RadioClassViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray<RadioClassModel *> *dataArr;
@property (nonatomic, strong) NSMutableArray<RadioClassModel *> *showDataArr;

@property (nonatomic, assign) NSInteger defaultVisibilityNum;
@property (nonatomic, assign) RadioClassCellStyle style;
@property (nonatomic, assign) NSInteger currentClassIndex;

- (void)showAllDataArr;
- (void)showSectionDataArr;

@end
