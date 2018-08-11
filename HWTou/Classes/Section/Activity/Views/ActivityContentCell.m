//
//  ActivityContentCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityContentCell.h"
#import "ActivityNewsCollectDM.h"
#import "ActivityNewsDM.h"
#import "PublicHeader.h"

@interface ActivityContentCell ()
{
    UILabel         *_labTitle;
    UILabel         *_labRemark;
    UILabel         *_labRead;
    UILabel         *_labLike;
    
    UIImageView     *_imgvIcon;
    UIImageView     *_imgvRead;
    UIImageView     *_imgvLike;
}
@end

@implementation ActivityContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    
    return self;
}

#pragma mark - 页面初始化
- (void)creatUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _labTitle = [[UILabel alloc] init];
    _labTitle.font = FontPFMedium(15.0f);
    _labTitle.textColor = UIColorFromHex(0x333333);
    
    _labRemark = [[UILabel alloc] init];
    _labRemark.font = FontPFRegular(13.0f);
    _labRemark.textColor = UIColorFromHex(0x7f7f7f);
    _labRemark.numberOfLines = 3;
    
    _labRead = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xadadad) size:12.0f];
    _labLike = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xadadad) size:12.0f];
    
    _imgvRead = [[UIImageView alloc] init];
    _imgvLike = [[UIImageView alloc] init];
    _imgvIcon = [[UIImageView alloc] init];
    
    _imgvRead.image = [UIImage imageNamed:@"activity_list_read"];
    _imgvLike.image = [UIImage imageNamed:@"activity_list_like"];
    
    [self addSubview:_labTitle];
    [self addSubview:_labRemark];
    [self addSubview:_imgvIcon];
    
    [self addSubview:_labRead];
    [self addSubview:_labLike];
    [self addSubview:_imgvRead];
    [self addSubview:_imgvLike];
    
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgvIcon).offset(2.0f);
        make.leading.equalTo(self).offset(CoordXSizeScale(16));
        make.trailing.equalTo(_imgvIcon.leading).offset(-5);
    }];
    
    [_labRemark makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labTitle.bottom).offset(8.5);
        make.leading.trailing.equalTo(_labTitle);
    }];
    
    [_imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).multipliedBy(0.9);
        make.trailing.equalTo(self).offset(-9);
        make.width.equalTo(_imgvIcon.height);
        make.height.equalTo(self).multipliedBy(0.7);
    }];
    
    [_imgvRead makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(20.0f);
        make.bottom.equalTo(self).offset(-CoordXSizeScale(15.0f));
    }];
 
    [_labRead makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvRead.trailing).offset(5);
        make.centerY.equalTo(_imgvRead);
        make.width.equalTo(@50);
    }];
    
    [_imgvLike makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_labRead.trailing).offset(5);
        make.centerY.equalTo(_imgvRead);
    }];
    
    [_labLike makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvLike.trailing).offset(5);
        make.centerY.equalTo(_imgvLike);
    }];
}

- (void)setDmNews:(ActivityNewsDM *)dmNews
{
    _dmNews = dmNews;
    _labTitle.text = dmNews.title;
    _labRemark.text = dmNews.remark;
    _labRead.text = [NSString stringWithFormat:@"%ld", (long)dmNews.read_num];
    _labLike.text = [NSString stringWithFormat:@"%ld", (long)dmNews.alike_num];
    [_imgvIcon sd_setImageWithURL:[NSURL URLWithString:dmNews.img_url]];
}

@end
