//
//  SearchUserTableViewCell.h
//  HWTou
//
//  Created by robinson on 2017/12/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "PersonHomeDM.h"

@interface SearchUserTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *attend;
@property (weak, nonatomic) IBOutlet UILabel *fans;

@property (nonatomic,strong) PersonHomeDM * model;
@end
