//
//  RadioCateCell.h
//  HWTou
//
//  Created by Reyna on 2017/11/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioModel.h"
#import "PlayerHistoryModel.h"

@interface RadioCateCell : UITableViewCell

+ (NSString *)cellReuseIdentifierInfo;


- (void)bind:(RadioModel *)model;

- (void)content:(PlayerHistoryModel *)model;

@end
