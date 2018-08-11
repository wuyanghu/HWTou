//
//  TopicTitleCollectionCell.m
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TopicTitleCollectionCell.h"
#import "PublicHeader.h"

@implementation TopicTitleCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = UIColorFromHex(0xFAFAFA);
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.lineView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(60, 44));
            make.center.equalTo(self);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.titleLabel);
            make.width.equalTo(self.titleLabel);
            make.bottom.equalTo(self).offset(-1);
            make.height.equalTo(1);
        }];
        
        [self setSelectBgColor:NO];
    }
    return self;
}

- (void)setSelectBgColor:(BOOL)selected{
    if (selected) {
        self.titleLabel.textColor = UIColorFromHex(0xAD0021);
        self.lineView.hidden = NO;
    }else{
        self.titleLabel.textColor = UIColorFromHex(0x2B2B2B);
        self.lineView.hidden = YES;
    }
    
}

- (void)setLabelListModel:(TopicLabelListModel *)labelListModel{
    _labelListModel = labelListModel;
    self.titleLabel.text = labelListModel.labelName;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromHex(0xAD0021);
    }
    return _lineView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end


@implementation TopicTitleArrowCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = UIColorFromHex(0xFAFAFA);
        
        [self addSubview:self.imgBtn];
        
        [self.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}

- (void)buttonSelected:(UIButton *)button{
//    _imgBtn.selected = !_imgBtn.selected;
    [_btnSelectedDelegate buttonSelected:button];
}

- (UIButton *)imgBtn{
    if (!_imgBtn) {
        _imgBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonSelected:)];
        [_imgBtn setImage:[UIImage imageNamed:@"open_red"] forState:UIControlStateNormal];
        [_imgBtn setImage:[UIImage imageNamed:@"close_red"] forState:UIControlStateSelected];
        _imgBtn.tag = arrowsBtnType;
        _imgBtn.selected = NO;
    }
    return _imgBtn;
}
@end
