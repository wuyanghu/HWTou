//
//  CopperCollectionViewCell.m
//  HWTou
//
//  Created by 张维扬 on 2017/8/8.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CopperCollectionViewCell.h"
#import "InvestAccountDM.h"
#import "PublicHeader.h"

@interface CopperCollectionViewCell ()
{
    UIImageView *_imageView;
    UILabel *_label;
}
@end

@implementation CopperCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _imageView = [BasisUITool getImageViewWithImage:@"" withIsUserInteraction:NO];
    [self.contentView addSubview:_imageView];
    
    _label = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x6b6b6b) size:12];
    _label.font = FontPFRegular(12);
    [self.contentView addSubview:_label];
    
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.top).offset(CoordYSizeScale(25));
        make.centerX.equalTo(self.centerX);
    }];
    [_label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(_imageView.bottom).offset(CoordYSizeScale(8));
    }];
}

- (void)setDmAccount:(InvestFunctionDM *)dmAccount
{
    _dmAccount = dmAccount;
    _label.text = dmAccount.title;
    _imageView.image = [UIImage imageNamed:dmAccount.imgName];
}

@end
