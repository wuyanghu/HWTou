//
//  ShieldTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/3/28.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "ShieldTableViewCell.h"
#import "PublicHeader.h"

@interface ShieldTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation ShieldTableViewCell

- (void)setFocusUserListDM:(FocusUserListDM *)focusUserListDM{
    _focusUserListDM = focusUserListDM;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:focusUserListDM.headUrl]];
    self.nickNameLabel.text = focusUserListDM.nickname;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
