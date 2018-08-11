//
//  ConsumptionDetailCell.m
//  HWTou
//
//  Created by 赤 那 on 2017/4/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ConsumptionDetailCell.h"
#import "ConsumpGoldDetailDM.h"

#define kCourseColViewCellId       (@"CourseColCellId")

#import "PublicHeader.h"

@interface ConsumptionDetailCell ()

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labRemark;
@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UILabel *labMoney;

@end

@implementation ConsumptionDetailCell

#pragma mark - 初始化
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self addViews];
        [self layoutUI];
    }
    
    return self;
}


- (void)addViews{

    self.labTitle = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(0x333333) size:14.0f];
    [self addSubview:self.labTitle];
    
    self.labRemark = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(0xefaa51) size:12];
    [self addSubview:self.labRemark];
    
    self.labTime = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(0xc4c4c4) size:12];
    [self addSubview:self.labTime];
    
    self.labMoney = [BasisUITool getBoldLabelWithTextColor:UIColorFromHex(0x333333) size:14.0f];
    [self addSubview:self.labMoney];
}

#pragma mark - Public Functions
- (void)layoutUI
{
    [self.labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.centerY);
        make.leading.equalTo(self).offset(12);
    }];
    
    [self.labRemark makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.labTitle);
        make.top.equalTo(self.labTitle.bottom).offset(5);
        
    }];
    
    [self.labMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTitle);
        make.trailing.equalTo(self).offset(-16);
    }];
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labRemark);
        make.trailing.equalTo(self.labMoney);
    }];
}

- (void)setDmDetail:(ConsumpGoldDetailDM *)dmDetail
{
    _dmDetail = dmDetail;
    self.labTitle.text = dmDetail.status;
    if (dmDetail.type == 1) {
        self.labMoney.text = [NSString stringWithFormat:@"%@(冻结)",dmDetail.price];
    } else {
        self.labMoney.text = dmDetail.price;
    }
    self.labTime.text = dmDetail.create_time;
    if (dmDetail.acct_name.length > 0 && dmDetail.card_no.length > 0) {
        self.labRemark.text = [NSString stringWithFormat:@"%@  %@", dmDetail.acct_name ?: @"", dmDetail.card_no ?: @""];
    } else {
        self.labRemark.text = [NSString stringWithFormat:@"%@  %@", dmDetail.tname ?: @"", dmDetail.money ?: @""];
    }
}
@end
