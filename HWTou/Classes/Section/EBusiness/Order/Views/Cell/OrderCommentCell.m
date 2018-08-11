//
//  OrderCommentCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderCommentCell.h"
#import "PublicHeader.h"

@interface CommentTextCell ()
{
    UIImageView     *_imgvHeader;
    UILabel         *_labName;
    UILabel         *_labTime;
    UILabel         *_labContent;
    UILabel         *_labParam;
}
@end

@implementation CommentTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        [self setupData];
    }
    return self;
}

- (void)createUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _imgvHeader = [[UIImageView alloc] init];
    _labName = [self createLabel];
    _labTime = [self createLabel];
    _labParam = [self createLabel];
    _labContent = [self createLabel];
    _labContent.numberOfLines = 0;
    _labContent.font = FontPFRegular(14.0f);
    _labTime.textColor = UIColorFromHex(0x7f7f7f);
    _labParam.textColor = UIColorFromHex(0x7f7f7f);
    
    [self addSubview:_imgvHeader];
    [self addSubview:_labName];
    [self addSubview:_labTime];
    [self addSubview:_labParam];
    [self addSubview:_labContent];
    
    [_imgvHeader makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.trailing).multipliedBy(0.04);
        make.top.equalTo(self).offset(12);
        make.size.equalTo(CGSizeMake(CoordXSizeScale(35), CoordXSizeScale(35)));
    }];
    
    [_labName makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvHeader.trailing).offset(15);
        make.centerY.equalTo(_imgvHeader);
    }];
    
    [_labTime makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgvHeader);
        make.trailing.equalTo(self).offset(-CoordXSizeScale(16));
    }];
    
    [_labContent makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvHeader);
        make.trailing.lessThanOrEqualTo(_labTime);
        make.top.equalTo(_imgvHeader.bottom).offset(CoordXSizeScale(15));
    }];
    
    [_labParam makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvHeader);
//        make.top.equalTo(_labContent.bottom).offset(10);
        make.bottom.equalTo(self.bottom).offset(-CoordXSizeScale(15));
    }];
}

- (void)setupData
{
    _labName.text = @"王****二";
    _labTime.text = @"2017-03-22 09:29";
    _labContent.text = @"好评。。";
    _labParam.text = @"银色";
    _imgvHeader.image = [UIImage imageNamed:@"test_commet_header"];
}

- (UILabel *)createLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromHex(0x333333);
    label.font = FontPFRegular(12);
    return label;
}

@end

@interface OrderCommentCell ()
{
    UIImageView     *_imgvHeader;
    UILabel         *_labName;
    UILabel         *_labTime;
    UILabel         *_labContent;
    UILabel         *_labParam;
    UIView          *_vPhotos;
}
@end

@implementation OrderCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _imgvHeader = [[UIImageView alloc] init];
    _labName = [self createLabel];
    _labTime = [self createLabel];
    _labParam = [self createLabel];
    _labContent = [self createLabel];
    _labContent.numberOfLines = 0;
    _labContent.font = FontPFRegular(14.0f);
    _labTime.textColor = UIColorFromHex(0x7f7f7f);
    _labParam.textColor = UIColorFromHex(0x7f7f7f);
    
    _vPhotos = [[UIView alloc] init];
    [self.contentView addSubview:_imgvHeader];
    [self.contentView addSubview:_labName];
    [self.contentView addSubview:_labTime];
    [self.contentView addSubview:_labParam];
    [self.contentView addSubview:_labContent];
    [self.contentView addSubview:_vPhotos];
    
    [_imgvHeader makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.trailing).multipliedBy(0.04);
        make.top.equalTo(self.contentView).offset(12);
        make.size.equalTo(CGSizeMake(CoordXSizeScale(35), CoordXSizeScale(35)));
    }];
    
    [_labName makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvHeader.trailing).offset(15);
        make.centerY.equalTo(_imgvHeader);
    }];
    
    [_labTime makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgvHeader);
        make.trailing.equalTo(self.contentView).offset(-CoordXSizeScale(16));
    }];
    
    [_labContent makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvHeader);
        make.trailing.lessThanOrEqualTo(_labTime);
        make.top.equalTo(_imgvHeader.bottom).offset(CoordXSizeScale(15));
    }];
    
    // 预先创建4个图片控件
    UIView *viewLast = nil;
    for (int index = 1; index < 5; index++) {
        UIImageView *imgvPhoto = [[UIImageView alloc] init];
        [_vPhotos addSubview:imgvPhoto];
        viewLast = imgvPhoto;
        imgvPhoto.image = [UIImage imageNamed:@"test_commet_photo"];
        
        [imgvPhoto makeConstraints:^(MASConstraintMaker *make) {
            // 图片宽度占比20% + 间距宽度占比为4%
            CGFloat ratio = 0.2 * index + 0.04 * index;
            make.trailing.equalTo(_vPhotos).multipliedBy(ratio);
            make.width.equalTo(_vPhotos).multipliedBy(0.2);
            make.height.equalTo(imgvPhoto.width);
            make.top.equalTo(_vPhotos);
        }];
    }
    
    [_vPhotos makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labContent.bottom).offset(10);
        make.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(viewLast);
    }];
    
    [_labParam makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvHeader);
        make.top.equalTo(_vPhotos.bottom).offset(10);
        make.bottom.equalTo(self.contentView.bottom).offset(-CoordXSizeScale(15));
    }];
}

- (void)setupData
{
    _labName.text = @"王****二";
    _labTime.text = @"2017-03-22 09:29";
    _labContent.text = @"好评。。";
    _labParam.text = @"银色";
    _imgvHeader.image = [UIImage imageNamed:@"test_commet_header"];
}

- (UILabel *)createLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromHex(0x333333);
    label.font = FontPFRegular(12);
    return label;
}

@end
