//
//  OrderMailCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderMailCell.h"
#import "OrderMailReq.h"
#import "PublicHeader.h"

@interface OrderMailCell ()
{
    UIImageView     *_imgvPoint;
    UIImageView     *_imgvLineUp;
    UIImageView     *_imgvLineDown;
    
    UILabel         *_labTime;
    UILabel         *_labContent;
}
@end

@implementation OrderMailCell

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
    self.backgroundColor = UIColorFromHex(0xf4f4f4);
    
    _imgvPoint = [[UIImageView alloc] init];
    _imgvLineUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_mail_timeline"]];
    _imgvLineDown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_mail_timeline"]];
    
    _labTime = [[UILabel alloc] init];
    _labTime.font = FontPFRegular(12.0f);
    _labTime.textColor = UIColorFromHex(0x7f7f7f);
    
    _labContent = [[UILabel alloc] init];
    _labContent.font = FontPFRegular(13.0f);
    _labContent.numberOfLines = 3; // 后面考虑自适应
    
    [self addSubview:_imgvPoint];
    [self addSubview:_imgvLineUp];
    [self addSubview:_imgvLineDown];
    
    [self addSubview:_labTime];
    [self addSubview:_labContent];
    
    [_imgvPoint makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(12, 15));
        make.leading.equalTo(15.0f);
    }];
    
    [_imgvLineUp makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(_imgvPoint);
        make.bottom.equalTo(_imgvPoint.top);
    }];
    
    [_imgvLineDown makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(_imgvPoint);
        make.top.equalTo(_imgvPoint.bottom);
    }];
    
    [_labTime makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.centerY);
        make.leading.equalTo(_imgvPoint.trailing).offset(5);
    }];
    
    [_labContent makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerY);
        make.leading.equalTo(_labTime);
        make.trailing.lessThanOrEqualTo(self).offset(-20);
    }];
}

- (void)setDmMail:(OrderMailDM *)dmMail
{
    _dmMail = dmMail;
    _labTime.text = dmMail.accept_time;
    _labContent.text = dmMail.accept_station;
}

- (void)setCellRow:(NSInteger)row total:(NSInteger)total
{
    if (row == 0) {
        _labContent.textColor = UIColorFromHex(0xad0021);
        _imgvPoint.image = [UIImage imageNamed:@"shop_mail_point_hlt"];
    } else {
        _imgvPoint.image = [UIImage imageNamed:@"shop_mail_point"];
        _labContent.textColor = UIColorFromHex(0x333333);
    }

    if (row == 0 || total <= 1) {
        _imgvLineUp.hidden = YES;
    } else {
        _imgvLineUp.hidden = NO;
    }
    
    if (row == total - 1 || total <= 1) {
        _imgvLineDown.hidden = YES;
    } else {
        _imgvLineDown.hidden = NO;
    }
}
@end
