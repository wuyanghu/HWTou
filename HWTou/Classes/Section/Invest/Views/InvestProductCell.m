//
//  InvestProductCell.m
//  HWTou
//
//  Created by 彭鹏 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "InvestProductCell.h"
#import "ZZCACircleProgress.h"
#import "InvestProductDM.h"
#import "PublicHeader.h"
#import "RDInfoReq.h"

@interface InvestProductCell ()
{
    UILabel     *_labName;
    UILabel     *_labTag1;
    UILabel     *_labTag2;
    UILabel     *_labRateYear;
    UILabel     *_labRateOther;
    UILabel     *_labTimeLimit;
    UILabel     *_labAmount;
    
    UIImageView *_imgvForward;
    UILabel     *_labStatus;
}
@property (nonatomic, strong) ZZCACircleProgress  *vProgress;

@end

@implementation InvestProductCell

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
    self.vProgress = [[ZZCACircleProgress alloc] initWithFrame:CGRectMake(0, 0, 50, 50) pathBackColor:UIColorFromHex(0xd6d7dc) pathFillColor:UIColorFromHex(0xfe5850) startAngle:-90 strokeWidth:2.0f];
    
    self.vProgress.progressLabel.font = FontPFRegular(13.0f);
    self.vProgress.progressLabel.textColor = UIColorFromHex(0xfe5850);
    self.vProgress.duration = 1.0;//动画时长
    self.vProgress.showPoint = NO;
//    self.vProgress.prepareToShow = YES;
    
    _labStatus = [[UILabel alloc] init];
    _labStatus.font = FontPFRegular(12.0f);
    _labStatus.textColor = UIColorFromHex(0xd6d7dc);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *vLineH = [[UIView alloc] init];
    vLineH.backgroundColor = UIColorFromHex(0xd6d7dc);
    
    UIView *vLineV = [[UIView alloc] init];
    vLineV.backgroundColor = UIColorFromHex(0xd6d7dc);
    
    [self addSubview:vLineH];
    [self addSubview:vLineV];
    
    [self addSubview:self.vProgress];
    [self.vProgress addSubview:_labStatus];
    
    [self.vProgress makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(50);
        make.centerY.equalTo(vLineV);
        make.trailing.equalTo(-12);
    }];
    
    [_labStatus makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.vProgress);
    }];
    
    [vLineH makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40);
        make.trailing.leading.equalTo(self);
        make.height.equalTo(0.5);
    }];
    
    [vLineV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).multipliedBy(0.85);
        make.bottom.equalTo(-15);
        make.height.equalTo(50);
        make.width.equalTo(1);
    }];
    
    _labName = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:16];
    _labRateYear = [BasisUITool getLabelWithTextColor:UIColorFromHex((0xfe5850)) size:20];
    _labRateOther = [BasisUITool getLabelWithTextColor:UIColorFromHex((0xfe5850)) size:20];
    _labTimeLimit = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:12];
    _labAmount = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x333333) size:12];
    
    UILabel *titleRate = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x909090) size:10];
    UILabel *titleTime = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x909090) size:10];
    UILabel *titleAmount = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x909090) size:10];
    titleRate.text = @"预计年化率";
    titleTime.text = @"项目期限";
    titleAmount.text = @"项目总额";

    [self addSubview:titleRate];
    [self addSubview:titleTime];
    [self addSubview:titleAmount];
    
    _imgvForward = [[UIImageView alloc] init];
    _imgvForward.image = [UIImage imageNamed:@"ahead_money"];
    
    _labTag1 = [BasisUITool getLabelWithTextColor:[UIColor whiteColor] size:12];
    _labTag2 = [BasisUITool getLabelWithTextColor:[UIColor whiteColor] size:12];
    [_labTag1 setRoundWithCorner:2];
    [_labTag2 setRoundWithCorner:2];
    _labTag1.textAlignment = NSTextAlignmentCenter;
    _labTag2.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_labName];
    [self addSubview:_labRateYear];
    [self addSubview:_labRateOther];
    [self addSubview:_labTimeLimit];
    [self addSubview:_labAmount];
    [self addSubview:_labTag1];
    [self addSubview:_labTag2];
    [self addSubview:_imgvForward];
    
    _labAmount.adjustsFontSizeToFitWidth = YES;
    _labRateYear.adjustsFontSizeToFitWidth = YES;
    
    [_labName makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.lessThanOrEqualTo(_labTag2.leading).offset(-5);
        make.bottom.equalTo(vLineH.top);
        make.top.equalTo(self);
        make.leading.equalTo(10);
    }];
    
    [_labTag1 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_labName);
        make.trailing.equalTo(-15);
        make.width.height.equalTo(18);
    }];
    
    [_labTag2 makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_labName);
        make.trailing.equalTo(_labTag1.leading).offset(-5);
        make.width.height.equalTo(18);
    }];
    
    [_labRateYear makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15);
        make.baseline.equalTo(vLineV.centerY);
        make.trailing.equalTo(vLineV).offset(-10);
    }];
    
    [_imgvForward makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_labRateYear);
        make.bottom.equalTo(vLineV.top).offset(5);
    }];
    
    [titleRate makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15);
        make.top.equalTo(_labRateYear.bottom);
    }];
    
    [titleTime makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(vLineV).offset(12);
        make.bottom.equalTo(vLineV.centerY).offset(-4);
    }];
    
    [titleAmount makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(vLineV).offset(12);
        make.top.equalTo(vLineV.centerY).offset(4);
        make.width.equalTo(titleAmount.intrinsicContentSize.width);
    }];
    
    [_labTimeLimit makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleTime);
        make.leading.equalTo(titleTime.trailing).offset(3);
    }];
    
    [_labAmount makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleAmount);
        make.trailing.equalTo(self.vProgress.leading).offset(-5);
        make.leading.equalTo(titleAmount.trailing).offset(3);
    }];
}

- (void)setDmProduct:(InvestProductDM *)dmProduct
{
    _dmProduct = dmProduct;
    _labName.text = dmProduct.name;
    
    NSString *timeUnit = dmProduct.timeType ? @"天" : @"月";
    _labTimeLimit.text = [NSString stringWithFormat:@"%@%@", dmProduct.timeLimit, timeUnit];
    _labAmount.text = [NSString stringWithFormat:@"%@元", dmProduct.formatBorrow];
    
    NSString *strBig = [NSString stringWithFormat:@"%d", dmProduct.rateYear.intValue];
    
    NSString *strRateYear = [NSString stringWithFormat:@"%.2f%%", dmProduct.rateYear.floatValue];
    
    _imgvForward.hidden = YES;
    if (dmProduct.dmForward) { // 提前花
        _imgvForward.hidden = NO;
        strRateYear = [NSString stringWithFormat:@"%@+%@%%", strRateYear, dmProduct.dmForward.rate];
    } else if (dmProduct.platformRateYear.floatValue > 0) {
        strRateYear = [NSString stringWithFormat:@"%@+%.2f%%", strRateYear, dmProduct.platformRateYear.floatValue];
    }
    
    NSMutableAttributedString *attRate = [[NSMutableAttributedString alloc] initWithString:strRateYear];
    [attRate addAttribute:NSFontAttributeName value:FontPFRegular(30.0f) range:NSMakeRange(0, strBig.length)];
    _labRateYear.attributedText = attRate;
    
    [self setTagContent];
    [self setProductStatus];
}

- (void)setProductStatus
{
    NSString *strStatus = nil;
    CGFloat progress = 0;
    self.vProgress.showProgressText = NO;
    _labStatus.hidden = NO;
    
    switch (self.dmProduct.status) {
        case 1: // 招标中
            self.vProgress.showProgressText = YES;
            _labStatus.hidden = YES;
            strStatus = [NSString stringWithFormat:@"%@%%", self.dmProduct.progressPercentage];
            progress = self.dmProduct.progressPercentage.floatValue/100.0f;
            break;
        case 3: // 满标待审
            strStatus = @"已满标";
            break;
        case 4: // 还款中
            strStatus = @"还款中";
            break;
        case 8: // 已还款
            strStatus = @"已还款";
            break;
        default:
            break;
    }
    self.vProgress.progress = progress;
    _labStatus.text = strStatus;
}

- (void)setTagContent
{
    NSString *strType;
    UIColor *colorType;
    switch (self.dmProduct.type) {
        case 101:
            strType = @"担";
            break;
        case 102:
            strType = @"抵";
            colorType = UIColorFromHex(0x2388d9);
            break;
        case 103:
            strType = @"信";
            colorType = UIColorFromHex(0xfab53e);
            break;
        case 104:
            strType = @"秒";
            break;
        default:
            break;
    }
    
    BOOL isForward = self.dmProduct.dmForward ? YES : NO;
    _labTag2.hidden = YES;
    if (colorType) {
        _labTag1.hidden = NO;
        _labTag1.backgroundColor = colorType;
        _labTag1.text = strType;
        
        if (isForward) {
            _labTag2.hidden = NO;
            _labTag2.backgroundColor = UIColorFromHex(0xfe5850);
            _labTag2.text = @"花";
        }
        
    } else if (isForward) {
        _labTag1.hidden = NO;
        _labTag1.backgroundColor = UIColorFromHex(0xfe5850);
        _labTag1.text = @"花";
    } else {
        _labTag1.hidden = YES;
    }
}
@end
