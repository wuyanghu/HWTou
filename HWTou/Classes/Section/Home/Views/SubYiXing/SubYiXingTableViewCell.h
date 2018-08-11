//
//  SubYiXingTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GetFayeArtModel.h"

@interface SubYiXingTableViewCell : BaseTableViewCell
@property (nonatomic,strong) GetFayeArtModel * getFayeArtModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
