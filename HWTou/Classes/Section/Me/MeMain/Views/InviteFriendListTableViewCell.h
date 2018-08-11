//
//  InviteFriendListTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/1/16.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "InviteFrendModel.h"

@interface InviteFriendListTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong) InviteFrendModel * friendModel;
@end
