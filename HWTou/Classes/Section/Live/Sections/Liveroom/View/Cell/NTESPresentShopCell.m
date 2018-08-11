//
//  NTESPresentShopCell.m
//  NIMLiveDemo
//
//  Created by chris on 16/3/29.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESPresentShopCell.h"
#import "UIView+NTES.h"

@interface NTESPresentShopCell()

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *nameLabel;

@end

@implementation NTESPresentShopCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:13.f];
        self.nameLabel.textColor = UIColorFromRGB(0xffffff);
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor blackColor];
        self.selectedBackgroundView = view;
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)refreshPresent:(NTESPresent *)present
{
    UIImage *image = [UIImage imageNamed:present.icon];
    self.imageView.image = image;
    [self.imageView sizeToFit];
    
    self.nameLabel.text = present.name;
    [self.nameLabel sizeToFit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat top = 15.f * UISreenWidthScale;
    CGFloat bottom = 5.f * UISreenWidthScale;
    self.imageView.ntesTop = top;
    self.imageView.ntesCenterX = self.ntesWidth * .5f;
    
    self.nameLabel.ntesBottom  = self.ntesHeight - bottom;
    self.nameLabel.ntesCenterX = self.ntesWidth * .5f;
}

@end
