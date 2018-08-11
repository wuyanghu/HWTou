//
//  RewardTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/3/28.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "RewardTableViewCell.h"
#import "PublicHeader.h"

@interface RewardTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@end

@implementation RewardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRewardModel:(RewardModel *)rewardModel{
    _rewardModel = rewardModel;
    
}

- (void)refresh:(RewardModel *)rewardModel selectRow:(NSInteger)selectRow{
    _rewardModel = rewardModel;
    if (selectRow<=2) {
        self.rankImageView.hidden = NO;
        self.rankLabel.hidden = YES;
        NSArray * rankArr = @[@"ds_img_no1",@"ds_img_no2",@"ds_img_no3"];
        self.rankImageView.image = [UIImage imageNamed:rankArr[selectRow]];
    }else{
        self.rankImageView.hidden = YES;
        self.rankLabel.hidden = NO;
        self.rankLabel.text = [NSString stringWithFormat:@"%ld",selectRow+1];
    }
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:rewardModel.avater]];
    self.nickNameLabel.text = rewardModel.nickName;
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",rewardModel.tipMoney];
    
}

@end
