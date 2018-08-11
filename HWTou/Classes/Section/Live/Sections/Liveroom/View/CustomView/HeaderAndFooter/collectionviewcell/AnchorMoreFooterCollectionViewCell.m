//
//  AnchorMoreFooterCollectionViewCell.m
//  HWTou
//
//  Created by robinson on 2018/3/22.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AnchorMoreFooterCollectionViewCell.h"

@interface AnchorMoreFooterCollectionViewCell()

@end

@implementation AnchorMoreFooterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)cellIdentity{
    return @"AnchorMoreFooterCollectionViewCell";
}

- (void)setImageTitleDict:(NSDictionary *)imageTitleDict isNormal:(BOOL)isNormal{
    _imageTitleDict = imageTitleDict;
    if (isNormal) {
        self.imageView.image = [UIImage imageNamed:imageTitleDict[imgKey]];
        self.titleLabel.text = imageTitleDict[titleKey];
    }else{
        self.imageView.image = [UIImage imageNamed:imageTitleDict[selectimgKey]];
        self.titleLabel.text = imageTitleDict[selecttitleKey];
    }
}

@end
