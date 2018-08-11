//
//  RadioTypeCell.m
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioTypeCell.h"
#import "PublicHeader.h"

@interface RadioTypeCell ()

@property (nonatomic, strong) RadioClassViewModel *viewModel;

@end

@implementation RadioTypeCell

+ (NSString *)cellReuseIdentifierInfo {
    return @"RadioTypeCell";
}

- (void)bind:(RadioClassViewModel *)viewModel {
    if (viewModel) {
        self.viewModel = viewModel;
        NSInteger max = viewModel.showDataArr.count;
        
        [self removeAllResufulButton];
        
        CGFloat width = (kMainScreenWidth - 15) / 4.0f;
        for(NSInteger i = 0; i <=max; i++) {
            NSInteger col = i % 4; //列
            NSInteger cow = i / 4; //行
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((width + 5) * col, 5 + 50 * cow, width, 45);
            btn.backgroundColor = UIColorFromHex(0xf3f4f6);
            if (i == max) {
                NSString *imgName = viewModel.style == RadioClassCellStyleHidden ? @"open_red" : @"close_red";
                [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(showMoreOrHiddenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                if(i >= viewModel.showDataArr.count) {
                    continue;
                }
                RadioClassModel *m = viewModel.showDataArr[i];
                [btn setTitle:m.className forState:UIControlStateNormal];
                
                if (i == self.viewModel.currentClassIndex) {
                    [btn setTitleColor:UIColorFromHex(0xad0021) forState:UIControlStateNormal];
                }
                else {
                    [btn setTitleColor:UIColorFromHex(0x2b2b2b) forState:UIControlStateNormal];
                }
                
                btn.titleLabel.font = SYSTEM_FONT(14);
                btn.tag = 100 + i;
                [btn addTarget:self action:@selector(radioClassTypeAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self addSubview:btn];
        }
    }
}

- (void)radioClassTypeAction:(UIButton *)btn {
    
    if (btn.tag - 100 != self.viewModel.currentClassIndex) {
       
        
        UIButton *oldBtn = (UIButton *)[self viewWithTag:self.viewModel.currentClassIndex + 100];
        [oldBtn setTitleColor:UIColorFromHex(0x2b2b2b) forState:UIControlStateNormal];
        UIButton *newBtn = (UIButton *)[self viewWithTag:btn.tag];
        [newBtn setTitleColor:UIColorFromHex(0xad0021) forState:UIControlStateNormal];
        
         self.viewModel.currentClassIndex = btn.tag - 100;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(radioClassSelectAction:)]) {

        if (btn.tag - 100 < self.viewModel.dataArr.count) {
            RadioClassModel *m = [self.viewModel.dataArr objectAtIndex:btn.tag - 100];
            [self.delegate radioClassSelectAction:m];
        }
    }
}

- (void)showMoreOrHiddenButtonClick:(UIButton *)btn {
    if(self.showMoreOrHiddenBlock) {
        self.showMoreOrHiddenBlock(self);
    }
}

- (void)removeAllResufulButton {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
}

- (RadioClassViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[RadioClassViewModel alloc] init];
    }
    return _viewModel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
