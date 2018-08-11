//
//  BaseBannerCell.m
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseBannerCell.h"
#import "RadioModel.h"

@interface BaseBannerCell()

@property (weak, nonatomic) IBOutlet UIImageView *firstIV;
@property (weak, nonatomic) IBOutlet UIImageView *twoIV;
@property (weak, nonatomic) IBOutlet UIImageView *threeIV;

@property (weak, nonatomic) IBOutlet UILabel *fisrtLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@end

@implementation BaseBannerCell

- (void)setDataArr:(NSMutableArray<RadioModel *> *)dataArr {
    
    if (dataArr.count > 0) {
        if (dataArr.count == 1) {
            self.firstIV.hidden = NO;
            self.twoIV.hidden = YES;
            self.threeIV.hidden = YES;
            
            self.fisrtLabel.hidden = NO;
            self.twoLabel.hidden = YES;
            self.threeLabel.hidden = YES;
            
            self.fisrtLabel.text = [dataArr[0] channelName];
        }
        else if (dataArr.count == 2) {
            self.firstIV.hidden = NO;
            self.twoIV.hidden = NO;
            self.threeIV.hidden = YES;
            
            self.fisrtLabel.hidden = NO;
            self.twoLabel.hidden = NO;
            self.threeLabel.hidden = YES;
            
            self.fisrtLabel.text = [dataArr[0] channelName];
            self.twoLabel.text = [dataArr[1] channelName];
        }
        else {
            self.firstIV.hidden = NO;
            self.twoIV.hidden = NO;
            self.threeIV.hidden = NO;
            
            self.fisrtLabel.hidden = NO;
            self.twoLabel.hidden = NO;
            self.threeLabel.hidden = NO;
            
            self.fisrtLabel.text = [dataArr[0] channelName];
            self.twoLabel.text = [dataArr[1] channelName];
            self.threeLabel.text = [dataArr[2] channelName];
        }
    }
    else {
        self.firstIV.hidden = YES;
        self.twoIV.hidden = YES;
        self.threeIV.hidden = YES;
        
        self.fisrtLabel.hidden = YES;
        self.twoLabel.hidden = YES;
        self.threeLabel.hidden = YES;
    }
}

+ (NSString *)cellReuseIdentifierInfo {
    return @"BaseBannerCell";
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
