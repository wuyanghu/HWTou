//
//  ActivityListCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityListCell.h"
#import "ActivityCollectDM.h"
#import "ActivityListDM.h"
#import "PublicHeader.h"

@interface ActivityListCell ()
{
    UILabel         *_labTitle;
    UILabel         *_labTime;
    UILabel         *_labSign;
    UILabel         *_labRead;
    UILabel         *_labLike;
    
    UIImageView     *_imgvRead;
    UIImageView     *_imgvLike;
    
    UIImageView     *_imgvSign;
    UIImageView     *_imgvIcon;
}
@end

@implementation ActivityListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    _labTitle = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:13.0f];
    _labTime = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x7f7f7f) size:12.0f];
    _labSign = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x7f7f7f) size:12.0f];
    
    _imgvIcon = [[UIImageView alloc] init];
    _imgvSign = [[UIImageView alloc] init];
    _imgvSign.image = [UIImage imageNamed:@"activity_sign_sel"];
    _labSign.text = @"您已报名";
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
   
    _labRead = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xadadad) size:12.0f];
    _labLike = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xadadad) size:12.0f];
    
    _imgvRead = [[UIImageView alloc] init];
    _imgvLike = [[UIImageView alloc] init];
    _imgvIcon = [[UIImageView alloc] init];
    
    _imgvRead.image = [UIImage imageNamed:@"activity_list_read"];
    _imgvLike.image = [UIImage imageNamed:@"activity_list_like"];
    
    [self addSubview:_labTitle];
    [self addSubview:_labTime];
    [self addSubview:_labSign];
    [self addSubview:_imgvSign];
    [self addSubview:_imgvIcon];
    [self addSubview:vLine];
    
    [self addSubview:_labRead];
    [self addSubview:_labLike];
    [self addSubview:_imgvRead];
    [self addSubview:_imgvLike];
    
    [_imgvRead makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvIcon.leading);
        make.bottom.equalTo(_labTime);
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

    [vLine makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_labTitle);
        make.trailing.bottom.equalTo(self);
        make.height.equalTo(Single_Line_Width);
    }];
    
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15.0f);
        make.leading.equalTo(self).offset(20.0);
        make.trailing.equalTo(self).offset(-15.0f);
    }];
    
    [_imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_labTitle);
        make.width.equalTo(_imgvIcon.height);
        make.top.equalTo(_labTitle.bottom).offset(10.0);
        make.height.equalTo(self).multipliedBy(0.52);
    }];
    
    [_labTime makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-CoordXSizeScale(15));
    }];
    
    [_labSign makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_labTime);
        make.bottom.equalTo(_labTime.top).offset(-5);
    }];
    
    [_imgvSign makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_labSign);
        make.trailing.equalTo(_labSign.leading).offset(-5);
    }];
}

- (void)setDmList:(ActivityListDM *)dmList
{
    _dmList = dmList;
    _labTitle.text = dmList.title;
    _labSign.hidden = _imgvSign.hidden = !dmList.sign_flag;
    _labRead.text = [NSString stringWithFormat:@"%ld", (long)dmList.read_num];
    _labLike.text = [NSString stringWithFormat:@"%ld", (long)dmList.alike_num];
    [_imgvIcon sd_setImageWithURL:[NSURL URLWithString:dmList.img_url]];
    
    if (dmList.type == 2) {
        _labTime.text = @"已结束";
    } else if (dmList.type == 3) {
        NSString *time = [self formatResidueTime:self.dmList.startDate];
        _labTime.text = [NSString stringWithFormat:@"距活动开始还剩%@", time];
    } else {
        NSString *time = [self formatResidueTime:self.dmList.endDate];
        _labTime.text = [NSString stringWithFormat:@"剩%@", time];
    }
}

- (NSString *)formatResidueTime:(NSDate *)date
{
    NSDate *dateCur = [NSDate date];
    
    //计算时间间隔（单位是秒）
    NSTimeInterval time = [date timeIntervalSinceDate:dateCur];
    
    //计算天数、时、分、秒
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minutes = ((int)time)%(3600*24)%3600/60;
    
    NSString *dateContent = [[NSString alloc] initWithFormat:@"%i天%i小时%i分", days, hours, minutes];
    return dateContent;
}
@end
