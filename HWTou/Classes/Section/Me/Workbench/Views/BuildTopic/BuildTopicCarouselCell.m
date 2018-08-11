//
//  BuildTopicCarouselCell.m
//  HWTou
//
//  Created by robinson on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BuildTopicCarouselCell.h"
#import "PublicHeader.h"
#import "TopicWorkDetailModel.h"

@implementation BuildTopicCarouselCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.vCarouselImg];
        [self.vCarouselImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVCarouselImgArr:(NSArray *)vCarouselImgArr{
    self.vCarouselImg.localImageNamesGroup = vCarouselImgArr;
    [self.vCarouselImg setContentMode:UIViewContentModeScaleAspectFill];
}

- (ComCarouselImageView *)vCarouselImg{
    if (!_vCarouselImg) {
        _vCarouselImg = [[ComCarouselImageView alloc] init];
        _vCarouselImg.delegate = self;
    }
    return _vCarouselImg;
}

@end


@implementation EnterEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.enterBtn];
        [self addSubview:self.editBtn];
        
        [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(95, 30));
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(15);
        }];
        
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.top.equalTo(self.enterBtn);
            make.right.equalTo(self).offset(-10);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)buttonSelected:(UIButton *)button{
    [_btnDelegate buttonSelected:button];
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonSelected:)];
        [_editBtn setImage:[UIImage imageNamed:@"cj_btn_editcover"] forState:UIControlStateNormal];
        _editBtn.tag = editBtnType;
    }
    return _editBtn;
}

- (UIButton *)enterBtn{
    if (!_enterBtn) {
        _enterBtn = [BasisUITool getBtnWithTarget:self action:@selector(buttonSelected:)];
        [_enterBtn setImage:[UIImage imageNamed:@"cj_sound"] forState:UIControlStateNormal];
        _enterBtn.tag = enterBtnType;
    }
    return _enterBtn;
}

@end

@implementation InputTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.textField];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-5);
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(5);
            make.width.equalTo(kMainScreenWidth-20);
        }];
        
    }
    return self;
}

//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//取消第一响应者
    return YES;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [BasisUITool getTextFieldWithTextColor:UIColorFromHex(0x2b2b2b) withSize:18 withPlaceholder:@"请输入标题" withDelegate:self];
        _textField.returnKeyType = UIReturnKeyDone;
    }
    return _textField;
}
@end

@implementation ShareContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.textView];
        
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-10);
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(13.5);
            make.width.equalTo(kMainScreenWidth-20);
        }];
        
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    //获得textView的初始尺寸
//    CGFloat width = CGRectGetWidth(textView.frame);
//    CGFloat height = CGRectGetHeight(textView.frame);
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
//    CGRect newFrame = textView.frame;
//    newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
//
//    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(newSize.height);
//    }];
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [BasisUITool getTextViewWithTextColor:UIColorFromHex(0x868686) withSize:14 withPlaceholder:@"分享内容" withDelegate:self];
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}
@end
