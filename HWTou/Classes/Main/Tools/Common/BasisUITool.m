//
//  BasisUITool.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BasisUITool.h"
#import "PublicHeader.h"

@implementation BasisUITool

+ (UILabel *)getLabelWithTextColor:(UIColor *)textColor size:(CGFloat)size{

    UILabel *label = [[UILabel alloc] init];
    
    [label setText:@""];
    [label setTextColor:textColor];
    [label setFont:FontPFRegular(size)];
    [label setBackgroundColor:[UIColor clearColor]];
    
    return label;
    
}

+ (UILabel *)getBoldLabelWithTextColor:(UIColor *)textColor size:(CGFloat)size{
    
    UILabel *label = [[UILabel alloc] init];
    
    [label setText:@""];
    [label setTextColor:textColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:FontPFRegular(size)];
    
    return label;
    
}

+ (UIButton *)getBtnWithTarget:(id)target action:(SEL)actionMethod{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn.layer setCornerRadius:6.0];
    [btn.layer setMasksToBounds:YES];
    
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn.titleLabel setFont:FontPFRegular(CLIENT_COMMON_FONT_BTN_SIZE)];
    
    if (target && actionMethod != NULL){
        
        [btn addTarget:target action:actionMethod forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return btn;
    
}
//正常按钮，不带圆角
+ (UIButton *)getNormalBtnWithTarget:(id)target action:(SEL)actionMethod{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn.titleLabel setFont:FontPFRegular(CLIENT_COMMON_FONT_BTN_SIZE)];
    if (target && actionMethod != NULL){
        [btn addTarget:target action:actionMethod forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
    
}

+ (UIImageView *)getImageViewWithImage:(NSString *)imageName withIsUserInteraction:(BOOL)isEnabled{
    
    UIImageView *imageView;
    
    if (IsStrEmpty(imageName)) {
        
        imageView = [[UIImageView alloc] init];
        
    }else{
        
        imageView = [[UIImageView alloc] initWithImage:ImageNamed(imageName)];
        
    }
    
    [imageView setUserInteractionEnabled:isEnabled];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    return imageView;
    
}

+ (UITextView *)getTextViewWithTextColor:(UIColor *)textColor withSize:(CGFloat)size
                           withPlaceholder:(NSString *)placeholder withDelegate:(id)delegate{
    UITextView * textView = [[UITextView alloc] init];
    textView.delegate = delegate;
    textView.tintColor = textColor;
    textView.font = FontPFRegular(size);
    textView.backgroundColor =[UIColor clearColor];
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = placeholder;
    placeholderLabel.font = FontPFRegular(size);
    placeholderLabel.textColor = UIColorFromHex(0x868686);
    placeholderLabel.numberOfLines = 0;
    [placeholderLabel sizeToFit];
    [textView addSubview:placeholderLabel];
    
    [textView setValue:placeholderLabel forKey:@"_placeholderLabel"];
    
    return textView;
}

+ (UITextField *)getTextFieldWithTextColor:(UIColor *)textColor withSize:(CGFloat)size
                           withPlaceholder:(NSString *)placeholder withDelegate:(id)delegate{
    
    UITextField *textField = [[UITextField alloc] init];
    
    [textField setDelegate:delegate];
    [textField setTextColor:textColor];
    [textField setTextAlignment:NSTextAlignmentLeft];
    [textField setFont:FontPFRegular(size)];
    
    [textField setMinimumFontSize:size];
    [textField setPlaceholder:placeholder];
    [textField setBorderStyle:UITextBorderStyleNone];   // 外框类型
    [textField setBackgroundColor:[UIColor clearColor]];

//    [textField setClearsOnBeginEditing:YES];        // 再次编辑时是否清空之前内容；默认 NO
    [textField setReturnKeyType:UIReturnKeyDefault];    // 设置 return 键
    [textField setKeyboardType:UIKeyboardTypeDefault];  // 键盘显示类型
    
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing]; // UITextField 的一件清除按钮是否出现
    [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];   // 编辑内容时垂直对齐方式
    
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];// 自动纠错 关闭
    
    return textField;
    
}

+ (UITextField *)getBoldTextFieldWithTextColor:(UIColor *)textColor withSize:(CGFloat)size
                               withPlaceholder:(NSString *)placeholder withDelegate:(id)delegate{
    
    UITextField *textField = [[UITextField alloc] init];
    
    [textField setDelegate:delegate];
    [textField setTextColor:textColor];
    [textField setTextAlignment:NSTextAlignmentLeft];
    [textField setFont:FontPFRegular(size)];
    
    [textField setMinimumFontSize:size];
    [textField setPlaceholder:placeholder];
    [textField setBorderStyle:UITextBorderStyleNone];   // 外框类型
    [textField setBackgroundColor:[UIColor clearColor]];
    
//    [textField setClearsOnBeginEditing:YES];            // 再次编辑时是否清空之前内容；默认 NO
    [textField setReturnKeyType:UIReturnKeyDefault];    // 设置 return 键
    [textField setKeyboardType:UIKeyboardTypeDefault];  // 键盘显示类型
    
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing]; // UITextField 的一件清除按钮是否出现
    [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];   // 编辑内容时垂直对齐方式
    
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];// 自动纠错 关闭
    
    return textField;
    
}

+ (UITableView *)getTableViewWithFrame:(CGRect)frame
                                 style:(UITableViewStyle)style
                              delegate:(id)delegate
                            dataSource:(id)dataSource
                         scrollEnabled:(BOOL)isScrollEnabled
                        separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle{

    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    
    [tableView setDelegate:delegate];
    [tableView setDataSource:dataSource];
    [tableView setScrollEnabled:isScrollEnabled];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:separatorStyle];
    
    if (separatorStyle != UITableViewCellSeparatorStyleNone) {
        
        UIView *view = [[UIView alloc] init];
        
        [view setBackgroundColor:[UIColor clearColor]];
        
        [tableView setTableFooterView:view];
        
    }else{
        
        [tableView setSeparatorColor:[UIColor clearColor]];
        
    }
    
    return tableView;
    
}

+ (CGSize)calculateSize:(NSString *)content font:(UIFont *)font{

    CGSize size = kSizeWithFont(content, font);
    
    return CGSizeMake(ceilf(size.width), ceilf(size.height));;
    
}

+ (void)imgLoadingProcessing:(UIImageView *)imgView imgUrl:(id)imgUrl
            placeholderImage:(UIImage *)defaultImg{

    if (IsNilOrNull(imgUrl)) {
        // 为空时展示默认头像图片
        [imgView setImage:defaultImg];
        
    }else{
        
        if([imgUrl isKindOfClass:[NSURL class]]){
            // 如果是 NSURL 类，则展示网络图片
            [imgView sd_setImageWithURL:imgUrl placeholderImage:defaultImg];
            
        }else if([imgUrl isKindOfClass:[NSString class]]){
            
            NSString *tmpStr = (NSString *)imgUrl;
            
            if ([imgUrl hasPrefix:@"http://"]) {
                
                // 若是 NSString 类，并且 NSString 类是以 "http://" 开头的，将该NSString视为一个有效网络图片链接，如上。
                NSURL *url = [NSURL URLWithString:
                              [tmpStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                [imgView sd_setImageWithURL:url placeholderImage:defaultImg];
                
            }else{
                
                // 若是 NSString 类，并且 NSString 类是不是以 "http://" 开头的，则将NSString视为一个有效本地图片名字，进行显示
                if (tmpStr.length > 0) {
                    
                    UIImage *img = [UIImage imageWithContentsOfFile:tmpStr];
                    
                    if (IsNilOrNull(img)) {
                        img = defaultImg;
                    }
                    if (IsNilOrNull(img)) {
                        img = ImageNamed(tmpStr);
                    }
                    if (IsNilOrNull(img)) {
                        img = defaultImg;
                    }
                    
                    [imgView setImage:img];
                    
                }else{
                    [imgView setImage:defaultImg];
                }
                
            }
            
        }
        
    }
    
}

+ (CAShapeLayer *)headPortraitRoundProcessing:(CGFloat)frame{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame/2, frame/2)
                                                        radius:frame/2
                                                    startAngle:0
                                                      endAngle:2*M_PI
                                                     clockwise:YES];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    
    [shape setPath:path.CGPath];
    
    return shape;
    
}

+ (CGFloat)heightForString:(NSObject *)object andWidth:(CGFloat)width{

    CGFloat height = 0;
    
    if ([object isKindOfClass:[UILabel class]]) {
        
        CGSize sizeToFit = [(UILabel *)object sizeThatFits:CGSizeMake(width, MAXFLOAT)];
        height = sizeToFit.height;
        
    }else if ([object isKindOfClass:[UITextView class]]){
        
        CGSize sizeToFit = [(UITextView *)object sizeThatFits:CGSizeMake(width, MAXFLOAT)];
        height = sizeToFit.height;
        
    }else{
        
        height = 0;
        
    }
    
    return height;
    
}

@end
