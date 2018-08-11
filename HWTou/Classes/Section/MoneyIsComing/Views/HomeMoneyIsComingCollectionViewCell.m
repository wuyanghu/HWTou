//
//  HomeMoneyIsComingCollectionViewCell.m
//  HWTou
//
//  Created by robinson on 2018/1/22.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "HomeMoneyIsComingCollectionViewCell.h"
#import "PublicHeader.h"

@implementation HomeMoneyIsComingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDetailVM:(PlayerDetailViewModel *)detailVM{
    _detailVM = detailVM;
    self.browseLabel.text = [NSString stringWithFormat:@"%d人听过",detailVM.lookNum];
    NSArray * bgArray = [_detailVM.bmgs componentsSeparatedByString:@","];
    if (bgArray.count>0) {
        [self.bgImageView sd_setImageWithURL:bgArray[0]];
    }
    
}

@end
