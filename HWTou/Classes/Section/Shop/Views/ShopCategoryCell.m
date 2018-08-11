//
//  ShopCategoryCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCategoryDM.h"
#import "ShopCategoryCell.h"
#import "ActivityNewsDM.h"
#import "PublicHeader.h"

@interface ShopCategoryCell ()

@property (nonatomic, strong) UIImageView *imgvIcon;
@property (nonatomic, strong) UILabel *labTitle;

@end

@implementation ShopCategoryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.imgvIcon = [[UIImageView alloc] init];
    self.imgvIcon.contentMode = UIViewContentModeScaleAspectFit;
    
    self.labTitle = [[UILabel alloc] init];
    self.labTitle.textColor = UIColorFromHex(0x333333);
    self.labTitle.font = FontPFRegular(12.0f);
    
    [self addSubview:self.imgvIcon];
    [self addSubview:self.labTitle];
    
    [self.imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.8);
        make.height.equalTo(self.imgvIcon.width);
    }];
    
    [self.labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)setCategory:(ProductCategoryList *)category
{
    _category = category;
    self.labTitle.text = category.name;
    
    // ToDo: 本地&网络两种图片混合显示出现错位问题，根本原因:连续两次刷新UI，“本地图片”位置的cell可能会被“网络图片”位置的cell复用，如果网络图片正在下载，然后被复用到了本地位置，下载完成后会设置当前cell的图片，这样就错位显示了。解决方案: 每次刷新cell的时候，先执行取消图片下载，这样本地图片位置复用正在下载的cell，就会停止下载，其他网络图片位置重新执行下载；
    [self.imgvIcon sd_cancelCurrentAnimationImagesLoad];
    
    if (category.mcid == -1) {
        self.imgvIcon.image = [UIImage imageNamed:@"com_category_more"];
    } else {
        [self.imgvIcon sd_setImageWithURL:[NSURL URLWithString:category.img_url]];
    }
}

- (void)setActCategory:(ActivityCategoryDM *)actCategory
{
    _actCategory = actCategory;
    self.labTitle.text = actCategory.name;
    // 注释说明同上方法
    [self.imgvIcon sd_cancelCurrentAnimationImagesLoad];
    if (actCategory.ncid == -1) {
        self.imgvIcon.image = [UIImage imageNamed:@"com_category_more"];
    } else {
        [self.imgvIcon sd_setImageWithURL:[NSURL URLWithString:actCategory.img_url]];
    }
}
@end
