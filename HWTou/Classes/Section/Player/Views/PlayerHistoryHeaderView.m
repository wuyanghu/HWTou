//
//  PlayerHistoryHeaderView.m
//  HWTou
//
//  Created by robinson on 2017/12/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PlayerHistoryHeaderView.h"
#import "PublicHeader.h"

@interface PlayerHistoryHeaderView()
{
    UIButton * selectBtn;
}
@end

@implementation PlayerHistoryHeaderView

- (instancetype)init{
    self = [super init];
    if (self) {
        _isCheck = NO;
        
        [self addView];
    }
    return self;
}

- (void)addView{
    selectBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonSelected:)];
    [selectBtn setImage:[UIImage imageNamed:@"lsbj_choice"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"selected_icon"] forState:UIControlStateSelected];
    selectBtn.tag = 101;
    [self addSubview:selectBtn];
    
    UILabel * selectLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:14];
    selectLabel.text = @"全选";
    [self addSubview:selectLabel];
    
//    UIButton * cancelBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonSelected:)];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    cancelBtn.tag = 102;
//    [cancelBtn setTitleColor:UIColorFromHex(0x2388D9) forState:UIControlStateNormal];
//    [self addSubview:cancelBtn];
    
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
        make.size.equalTo(CGSizeMake(22, 22));
    }];
    
    [selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectBtn.mas_right).offset(10);
        make.top.equalTo(selectBtn);
        make.centerY.equalTo(selectBtn);
        make.height.equalTo(selectBtn);
    }];
    
//    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.height.equalTo(selectBtn);
//        make.right.equalTo(self).offset(-20);
//    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromHex(0xDBD6D6);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(0.5);
        make.left.equalTo(self);
        make.width.equalTo(kMainScreenWidth);
        make.bottom.equalTo(self).offset(-0.5);
    }];
}

- (void)buttonSelected:(UIButton *)button{
    if (button.tag == 101) {
        _isCheck = button.selected;
        if (!_isCheck) {//没有选中
            _isCheck = YES;
            [_historyDelegate allSelected];
        }else{
            _isCheck = NO;
            [_historyDelegate cancelSelected];
        }
        
    }else if (button.tag == 102){
        _isCheck = NO;
        [_historyDelegate cancelSelected];

    }
    selectBtn.selected = _isCheck;
}

- (void)setIsCheck:(BOOL)isCheck{
    _isCheck = isCheck;
    selectBtn.selected = _isCheck;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
