//
//  HomeRadioSignTopView.m
//  HWTou
//
//  Created by Reyna on 2018/3/29.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "HomeRadioSignTopView.h"
#import "PublicHeader.h"

@interface HomeRadioSignTopView ()

@property (nonatomic, strong) UIScrollView *bgScrollView;

@end

@implementation HomeRadioSignTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    [self addSubview:self.bgScrollView];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    for (int i = 0; i<dataArray.count; i++) {
        HomeRadioSignModel *radioSignModel = dataArray[i];
        
        UIButton * button = [[UIButton alloc] init];
        button.tag = 100 + i;
        [button sd_setImageWithURL:[NSURL URLWithString:radioSignModel.bmg] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(10 + 170 * i, 0, 160, 105);
        [self.bgScrollView addSubview:button];
    }
    [self.bgScrollView setContentSize:CGSizeMake(10 + 170*_dataArray.count, 105)];
}

- (void)buttonAction:(UIButton *)button{
    HomeRadioSignModel * model = [_dataArray objectAtIndex:button.tag - 100];
    
    if (self.deleagte) {
        [self.deleagte itemSelected:model];
    }
}

#pragma mark - Get

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    }
    return _bgScrollView;
}

@end
