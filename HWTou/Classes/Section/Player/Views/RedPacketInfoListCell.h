//
//  RedPacketInfoListCell.h
//  HWTou
//
//  Created by Reyna on 2018/3/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetRedPacketDetailModel.h"

@interface RedPacketInfoListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

+ (NSString *)cellReuseIdentifierInfo;

- (void)bind:(GetRedPacketDetailModel *)model;

@end
