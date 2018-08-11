//
//  BaseBannerCell.h
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioModel;
@interface BaseBannerCell : UITableViewCell


+ (NSString *)cellReuseIdentifierInfo;
@property (nonatomic,strong) NSMutableArray<RadioModel *> * dataArr;

@end
