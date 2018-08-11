//
//  MoneyListCell.m
//  HWTou
//
//  Created by Reyna on 2018/2/2.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MoneyListCell.h"
#import "PublicHeader.h"

@interface MoneyListCell ()

@property (weak, nonatomic) IBOutlet UILabel *moneyNumLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation MoneyListCell

#pragma mark - Api

+ (NSString *)cellReuseIdentifierInfo {
    return @"MoneyListCell";
}

+ (CGFloat)singleCellHeight {
    return 63.f;
}

- (void)bind:(MoneyListModel *)model {
    
    if (model.financialType == 2) {
        self.moneyNumLab.text = [NSString stringWithFormat:@"-%@",model.realAmt];
        self.moneyNumLab.textColor = UIColorFromHex(0xff4d49);
        
        if (model.withdrawStatus == 0) {
            self.moneyInfoLab.text = @"提现中";
        }else if (model.withdrawStatus == 2) {
            self.moneyInfoLab.text = @"提现失败";
        }else if (model.withdrawStatus == 3) {
            self.moneyInfoLab.text = @"提现成功";
        }
    }
    else if (model.financialType == 5 || model.financialType == 8) {
        self.moneyNumLab.text = [NSString stringWithFormat:@"-%@",model.realAmt];
        self.moneyNumLab.textColor = UIColorFromHex(0xff4d49);
        self.moneyInfoLab.text = model.financialDesc;
    }
    else {
        self.moneyNumLab.text = [NSString stringWithFormat:@"+%@",model.realAmt];
        self.moneyNumLab.textColor = UIColorFromHex(0x42e496);
        self.moneyInfoLab.text = model.financialDesc;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *ordDate = [NSDate dateWithTimeIntervalSince1970:model.ordDate/1000];
    self.timeLab.text = [formatter stringFromDate:ordDate];
}

#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
