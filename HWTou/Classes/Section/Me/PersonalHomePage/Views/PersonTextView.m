//
//  PersonTextView.m
//  HWTou
//
//  Created by robinson on 2017/12/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonTextView.h"
#import "PublicHeader.h"

@implementation PersonTextView

#pragma mark ========== 通知 =============
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.textColor = [UIColor blackColor];
        
        // 设置占位文字的默认字体颜色和字体大小
        self.placeholderColor = [UIColor grayColor];
        self.font = [UIFont systemFontOfSize:15];
        
        // 发布通知（当空间的内容发生改变时）
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textDidChange:(NSNotification *)note{
    // 重绘
    [self setNeedsDisplay];
}

// 移除监听者
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ========== 绘制占位文字 ===========
// 绘制占位文字
- (void)drawRect:(CGRect)rect {
    // 如果有文字就不绘制（不执行下面的操作）
    if (self.text.length) return;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //    if (self.font) dict[NSFontAttributeName] = self.font;
    //    if (self.placeholderColor)  dict[NSForegroundColorAttributeName] = self.placeholderColor;
    dict[NSFontAttributeName] = self.font;
    dict[NSForegroundColorAttributeName] = self.placeholderColor;
    
    
    rect.origin.x = 4;
    rect.origin.y = 8;
    rect.size.width = kMainScreenWidth - 2 * rect.origin.x;
    
    [self.placeholder drawInRect:rect withAttributes:dict];
}

#pragma mark ========== 需要重写的属性 ===========
// 重写占位文字
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    // 重绘
    [self setNeedsDisplay];
}

// 重写占位文字颜色
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    // 重绘
    [self setNeedsDisplay];
}

// 重写占位文字字体大小
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    // 重绘
    [self setNeedsDisplay];
}

// 重写文字
- (void)setText:(NSString *)text{
    [super setText:text];
    // 重绘
    [self setNeedsDisplay];
}

// 重写文字属性
- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    // 重绘
    [self setNeedsDisplay];
}

// textView的尺寸发生改变
- (void)layoutSubviews{
    [super layoutSubviews];
    // 重绘
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
