//
//  RadioTopCell.h
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioModel.h"

@interface RadioTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topPlaceLab;

+ (NSString *)cellReuseIdentifierInfo;

- (void)bind:(RadioModel *)model;

+ (CGFloat)cellHeight;

@end
