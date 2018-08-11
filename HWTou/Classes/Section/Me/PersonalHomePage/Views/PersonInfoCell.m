//
//  PersonInfoView.m
//  HWTou
//
//  Created by robinson on 2017/11/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonInfoCell.h"
#import "PersonInfoLatelyAttendView.h"
#import "PublicHeader.h"
#import "BasisUITool.h"

@interface PersonInfoCell()
{
    UIButton * nextBtn;
    UIView * lineView;
}
@property (nonatomic,strong) UILabel * cityLabel;
@property (nonatomic,strong) UILabel * sexLabel;
@property (nonatomic,strong) UILabel * signLabel;

@property (nonatomic,strong) UILabel * recentlyAttentionLabel;
@property (nonatomic,strong) NSMutableDictionary * attendViewDict;

@end

@implementation PersonInfoCell

+ (NSString *)cellReuseIdentifierInfo{
    return @"cellReuseIdentifierInfo";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self drawMainView];
    }
    return self;
}

- (void)drawMainView{
    
    UILabel * sexLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8E8F91) size:12];
    sexLabel.text = @"性别";
    [self addSubview:sexLabel];
    
    [self addSubview:self.sexLabel];
    
    UILabel * cityLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8E8F91) size:12];
    cityLabel.text = @"城市";
    [self addSubview:cityLabel];
    
    [self addSubview:self.cityLabel];
    
    [sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.top.equalTo(self).offset(20);
        make.size.equalTo(CGSizeMake(30, 12));
    }];
    
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexLabel);
        make.top.equalTo(sexLabel.mas_bottom).offset(10);
        make.height.equalTo(13);
        make.width.mas_greaterThanOrEqualTo(30);
    }];
    
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sexLabel);
        make.size.equalTo(sexLabel);
        make.left.equalTo(self.sexLabel.mas_right).offset(20);
    }];
    
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cityLabel);
        make.top.equalTo(self.sexLabel);
        make.height.equalTo(cityLabel);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    UILabel * signLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x8E8F91) size:12];
    signLabel.text = @"个性签名";
    [self addSubview:signLabel];
    
    [self addSubview:self.signLabel];
    
    [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexLabel);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.cityLabel.mas_bottom).offset(20);
        make.height.equalTo(12);
    }];
    
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexLabel);
        make.width.equalTo(kMainScreenWidth-30);
        make.top.equalTo(signLabel.mas_bottom).offset(10);
        make.height.mas_greaterThanOrEqualTo(40);
    }];
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromHex(0xF3F4F6);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signLabel);
        make.top.equalTo(self.signLabel.mas_bottom).offset(22);
        make.width.equalTo(kMainScreenWidth);
        make.height.equalTo(0.5);
    }];
    
    [self addSubview:self.recentlyAttentionLabel];
    
    [self.recentlyAttentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexLabel);
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.size.equalTo(CGSizeMake(100, 13));
    }];
    
    nextBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
    [self addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.signLabel).offset(-10);
        make.size.equalTo(CGSizeMake(10, 18));
        make.top.equalTo(self.recentlyAttentionLabel.mas_bottom).offset(22);
        make.bottom.equalTo(self).offset(-75);
    }];
    
    
}

- (void)setPersonHomeModel:(PersonHomeDM *)personHomeModel{
    
    self.cityLabel.text = [personHomeModel getCity];
    self.sexLabel.text = [personHomeModel getSex];
    
    self.signLabel.text = [personHomeModel getSign];
    
    PersonInfoLatelyAttendView * attendView = nil;//记住的是最后一个
    
    if (personHomeModel.focusUsers.count == 0) {
        self.recentlyAttentionLabel.hidden = YES;
        nextBtn.hidden = YES;
        lineView.hidden = YES;
    }else{
        self.recentlyAttentionLabel.hidden = NO;
        nextBtn.hidden = NO;
        lineView.hidden = NO;
    }
    
    if (self.attendViewDict.count != personHomeModel.focusUsers.count) {
        for (PersonInfoLatelyAttendView * tempAttendView in self.attendViewDict.allValues) {
            [tempAttendView removeFromSuperview];
        }
        [self.attendViewDict removeAllObjects];
    }
    
    for (NSDictionary * focusDict in personHomeModel.focusUsers) {
        
        NSString * keyUid = focusDict[@"uid"];
        PersonInfoLatelyAttendView * tempAttendView = self.attendViewDict[keyUid];
        if (tempAttendView == nil) {
            tempAttendView = [[PersonInfoLatelyAttendView alloc] init];
            UITapGestureRecognizer* attendViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(attendViewTap:)];
            [tempAttendView addGestureRecognizer:attendViewTap];
            [self addSubview:tempAttendView];
            
            if (attendView == nil) {
                [tempAttendView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(10);
                    make.top.equalTo(self.recentlyAttentionLabel.mas_bottom).offset(10);
                    make.size.equalTo(CGSizeMake(40, 55));
//                    make.bottom.equalTo(self).offset(-10);
                }];
            }else{
                [tempAttendView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(attendView.mas_right).offset(20);
                    make.top.equalTo(attendView);
                    make.size.equalTo(attendView);
                }];
            }
            
            attendView = tempAttendView;
        }
       
        [tempAttendView setImageName:focusDict[@"headUrl"]];
        [tempAttendView setNickName:focusDict[@"nickname"]];
        
        [self.attendViewDict setObject:tempAttendView forKey:keyUid];
    }
}

#pragma mark - 点击事件

- (void)buttonSelected:(UIButton *)button{
    [_infoViewDelegate attendViewTapDelegate:nil];
}

//手势
- (void)attendViewTap:(UITapGestureRecognizer *)attendViewTap{
    [_infoViewDelegate attendViewTapDelegate:attendViewTap];
}

#pragma mark - getter

- (UILabel *)recentlyAttentionLabel{
    if (!_recentlyAttentionLabel) {
        _recentlyAttentionLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x646665) size:14];
        _recentlyAttentionLabel.text = @"最近关注";
    }
    return _recentlyAttentionLabel;
}

- (NSMutableDictionary *)attendViewDict{
    if (!_attendViewDict) {
        _attendViewDict = [NSMutableDictionary dictionary];
    }
    return _attendViewDict;
    
}
- (UILabel *)cityLabel{
    if (!_cityLabel) {
        _cityLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:14];
    }
    return _cityLabel;
}

- (UILabel *)sexLabel{
    if (!_sexLabel) {
        _sexLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:14];
    }
    return _sexLabel;
}

- (UILabel *)signLabel{
    if (!_signLabel) {
        _signLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:14];
        _signLabel.numberOfLines = 0;
    }
    return _signLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
