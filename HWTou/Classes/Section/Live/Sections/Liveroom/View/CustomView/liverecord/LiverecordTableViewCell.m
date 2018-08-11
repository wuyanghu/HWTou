//
//  LiverecordTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "LiverecordTableViewCell.h"
#import "PublicHeader.h"
#import "GetChatRecordsModel.h"

@interface LiverecordTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end

@implementation LiverecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"LiverecordTableViewCell";
}

- (void)setRecordsModel:(GetChatRecordsModel *)recordsModel{
    _recordsModel = recordsModel;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:recordsModel.chatAvater]];
    self.titleLabel.text = recordsModel.nickName;
    self.startTimeLabel.text = recordsModel.onlineTime;
    self.endTimeLabel.text = recordsModel.offlineTime;
}

@end
