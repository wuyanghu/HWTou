//
//  RadioTopCell.m
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioTopCell.h"
#import "PublicHeader.h"

@interface RadioTopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (weak, nonatomic) IBOutlet UIImageView *isRedIV;

@end

@implementation RadioTopCell

+ (NSString *)cellReuseIdentifierInfo {
    return @"RadioTopCell";
}

+ (CGFloat)cellHeight {
    return 78;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
