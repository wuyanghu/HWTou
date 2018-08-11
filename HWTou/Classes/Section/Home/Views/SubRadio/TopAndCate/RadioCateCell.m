//
//  RadioCateCell.m
//  HWTou
//
//  Created by Reyna on 2017/11/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioCateCell.h"
#import "PublicHeader.h"

@interface RadioCateCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;                                                                                                                                                                                                                                                                                                                                    
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *playIconIV;

@property (weak, nonatomic) IBOutlet UIImageView *isRedIV;

@end

@implementation RadioCateCell

+ (NSString *)cellReuseIdentifierInfo {
    return @"RadioCateCell";
}

- (void)bind:(RadioModel *)model {
    if (model) {
        [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.channelImg]];
        self.nameLab.text = model.channelName;
        self.infoLab.text = model.playing;
        self.numLab.text = [NSString stringWithFormat:@"%d",model.look];
        
        if (model.isRed) {
            self.isRedIV.hidden = NO;
        }
        else {
            self.isRedIV.hidden = YES;
        }
    }
}

- (void)content:(PlayerHistoryModel *)model {
    if (model) {
        [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.bmg]];
        self.nameLab.text = model.name;
        self.infoLab.text = model.playing;
        self.numLab.text = [NSString stringWithFormat:@"%d",model.lookNum];
    }
    
    self.playIconIV.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//处理选中背景色问题
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
