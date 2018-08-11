//
//  PersonEditCell.m
//  HWTou
//
//  Created by robinson on 2017/12/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonEditCell.h"
#import "PublicHeader.h"
#import "RegularExTool.h"

@implementation PersonEditCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



#pragma mark - CollectionViewCell

@implementation PersonCollectViewHeader
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromHex(0xF3F4F6);
    }
    return self;
}
@end

@implementation PersonEditIntroduceCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromHex(0xDBDBD6);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.top.equalTo(self);
            make.height.equalTo(0.5);
        }];
        
        UILabel * introduceLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:14];
        introduceLabel.text = @"介绍";
        [self addSubview:introduceLabel];
        [self addSubview:self.introduceBtn];
        [self addSubview:self.textField];
        
        self.textField.placeholder = @"简单介绍下自己吧";
        self.textField.returnKeyType = UIReturnKeyDone;
        
        [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(15);
            make.height.equalTo(13);
            make.width.equalTo(30);
        }];
        
        [self.introduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(introduceLabel.mas_right).offset(20);
            make.top.equalTo(self).offset(10);
            make.size.equalTo(CGSizeMake(14, 24));
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.introduceBtn.mas_right).offset(13);
            make.top.equalTo(introduceLabel);
            make.height.equalTo(13);
        }];
    }
    return self;
}

- (void)buttonSelected:(UIButton *)button{
    
}

//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//取消第一响应者
    return YES;
}

- (void)setPersonHomeModel:(PersonHomeDM *)personHomeModel{
    if (![self.personHomeModel.introduce isEqualToString:@""] || self.personHomeModel.introduce!=nil) {
        self.textField.text = self.personHomeModel.introduce;
    }
}

@end

@implementation PersonEditSignCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromHex(0xDBDBD6);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.top.equalTo(self);
            make.height.equalTo(0.5);
        }];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.textView];
        self.textView.returnKeyType = UIReturnKeyDone;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.textView.delegate = self;
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(15);
            make.height.equalTo(30);
            make.width.equalTo(30);
        }];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(13);
            make.top.equalTo(self.titleLabel);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(80);
        }];
    }
    return self;
}

- (void)setCellRow:(NSInteger)cellRow personHomeModel:(PersonHomeDM *)personHomeModel{
    self.titleLabel.text = @"签名";
    if (![personHomeModel.sign isEqualToString:@""] || personHomeModel.sign!=nil) {
        self.textView.text = personHomeModel.sign;
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    if (![RegularExTool validateSign:textView.text]){
        //截取
        [HUDProgressTool showErrorWithText:HINTSign];
        textView.text = [textView.text substringToIndex:textView.text.length-1];
    }
    return YES;
}

//-(void)textViewDidChange:(UITextView *)textView {
//    if (![RegularExTool validateSign:textView.text]) {
//        //不合法
//        [HUDProgressTool showErrorWithText:HINTSign];
//        return;
//    }
//}

@end


@implementation PersonEditNicknameCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromHex(0xDBDBD6);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.top.equalTo(self);
            make.height.equalTo(0.5);
        }];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.textField];
        self.textField.returnKeyType = UIReturnKeyDone;
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(15);
            make.height.equalTo(13);
            make.width.equalTo(30);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(13);
            make.top.equalTo(self.titleLabel);
            make.right.equalTo(self);
            make.height.equalTo(13);
        }];
        
    }
    return self;
}

//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//取消第一响应者
    return YES;
}

- (void)setCellRow:(NSInteger)cellRow personHomeModel:(PersonHomeDM *)personHomeModel{
    self.titleLabel.text = @"昵称";
    self.textField.placeholder = @"请输入昵称";
    if (![personHomeModel.nickname isEqualToString:@""] || personHomeModel.nickname != nil) {
        self.textField.text = personHomeModel.nickname;
    }
}

@end

@implementation PersonEditSexCityCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromHex(0xDBDBD6);
        [self addSubview:lineView];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.top.equalTo(self);
            make.height.equalTo(0.5);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(16);
            make.size.equalTo(CGSizeMake(28, 13));
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(20);
            make.top.equalTo(self.titleLabel);
            make.height.equalTo(self.titleLabel);
            make.width.equalTo(200);
        }];
    }
    return self;
}

- (void)setCellRow:(NSInteger)cellRow personHomeModel:(PersonHomeDM *)personHomeModel{
    if (cellRow == 1) {
        self.titleLabel.text = @"性别";
        self.subTitleLabel.text = [personHomeModel getSex];
    }else if (cellRow == 2){
        self.titleLabel.text = @"城市";
        self.subTitleLabel.text = [personHomeModel getCity];
    }
}

@end

@implementation PersonEditImgCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _headerImageView = [BasisUITool getImageViewWithImage:@"avatar" withIsUserInteraction:NO];
        [self addSubview:_headerImageView];
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(14, 14));
            make.left.top.equalTo(self).offset(5);
        }];
    }
    return self;
}

@end


@implementation PersonEditDataAddCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.image = [UIImage imageNamed:my_btn_add_1];
        [self addSubview:self.imageView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.equalTo(self).multipliedBy(0.5);
        }];
    }
    return self;
}

@end


@implementation BaseCollectViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setCellRow:(NSInteger)cellRow personHomeModel:(PersonHomeDM *)personHomeModel{
    
}

#pragma mark - getter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_SYSTEM_AVATAR withIsUserInteraction:NO];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView.layer setMasksToBounds:YES];
        
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2B2B2B) size:14];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x868686) size:14];
    }
    return _subTitleLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [BasisUITool getTextFieldWithTextColor:UIColorFromHex(0x868686) withSize:14 withPlaceholder:@"" withDelegate:self];
    }
    return _textField;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [BasisUITool getTextViewWithTextColor:UIColorFromHex(0x868686) withSize:14 withPlaceholder:@"暂无签名" withDelegate:0];
    }
    return _textView;
}

- (UIButton *)introduceBtn{
    if (!_introduceBtn) {
        _introduceBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonSelected:)];
        [_introduceBtn setBackgroundImage:[UIImage imageNamed:my_btn_mkf_default] forState:UIControlStateNormal];
        [_introduceBtn setBackgroundImage:[UIImage imageNamed:my_btn_mkf_click] forState:UIControlStateSelected];
    }
    return _introduceBtn;
}

@end
