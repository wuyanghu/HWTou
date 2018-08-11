//
//  RadioProgramDetailCell.m
//  HWTou
//
//  Created by robinson on 2017/11/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioProgramDetailCell.h"
#import "PublicHeader.h"

@implementation RadioProgramDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.playStateBtn];
        [self addSubview:self.timeLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-15);
            //宽度自适应
        }];
        
        [self.playStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.timeLabel.mas_left).offset(-15);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.width.equalTo(120);
            make.right.equalTo(self).offset(-10);
        }];
        
    }
    return self;
}

- (void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    
    self.titleLabel.text = dataDict[@"name"];
    
    NSDictionary * typeDict = @{@"1":@"直播",@"2":@"重播",@"3":@"预约"};
    NSString * type = [dataDict[@"type"] stringValue];
    [self.playStateBtn setTitle:typeDict[type] forState:UIControlStateNormal];
    if ([type isEqualToString:@"1"]) {
        [self.playStateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.playStateBtn setBackgroundColor:UIColorFromHex(0xff4d49)];
    }else{
        [self.playStateBtn setTitleColor:UIColorFromHex(0x646665) forState:UIControlStateNormal];
        [self.playStateBtn setBackgroundColor:UIColorFromHex(0xffffff)];
    }
    
    NSString * startTime = dataDict[@"startTime"];
    NSString * endTime = dataDict[@"endTime"];
    
    NSArray * startTimeArray = [startTime componentsSeparatedByString:@" "];
    NSArray * endTimeArray = [endTime componentsSeparatedByString:@" "];
    if (startTimeArray.count>1 && endTimeArray.count>1) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",startTimeArray[1],endTimeArray[1]];
    }else{
        self.timeLabel.text = @"--:-- - --:--";
    }
    
}

- (void)buttonSelected:(UIButton *)button{
    NSInteger type = _dataDict[@"type"];//节目格式，1：直播 ，2：重播，3：预约
    if (type == 1) {
        
    }else if (type == 2){
        
    }else{
        
    }
}

#pragma mark -  getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:14];
    }
    return _titleLabel;
}

- (UIButton *)playStateBtn{
    if (!_playStateBtn) {
        _playStateBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonSelected:)];
        [_playStateBtn setTitleColor:UIColorFromHex(0x646665) forState:UIControlStateNormal];
    }
    return _playStateBtn;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x646665) size:12];
    }
    return _timeLabel;
}

@end
