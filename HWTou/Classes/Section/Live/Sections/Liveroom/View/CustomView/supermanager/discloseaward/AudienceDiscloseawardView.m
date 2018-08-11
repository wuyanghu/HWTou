//
//  AudienceDiscloseawardView.m
//  HWTou
//
//  Created by robinson on 2018/4/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AudienceDiscloseawardView.h"
#import "UIView+NTES.h"

@interface AudienceDiscloseawardView()
@property (weak, nonatomic) IBOutlet UILabel *jlContentLabel;

@end

@implementation AudienceDiscloseawardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)onTapBackground:(id)sender
{
    [self dismiss];
}

- (void)show:(NTESAnchorDiscloseAttachment *)giveAttachment
{
    if (self.ntesTop == self.ntesHeight) {
        [self setSystemLabelText:giveAttachment];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.ntesTop -= self.ntesHeight;
        }];
    }
}

- (void)setSystemLabelText:(NTESAnchorDiscloseAttachment *)giveAttachment{
    NSString * content = [NSString stringWithFormat:@"%@ 获得 %@ 元奖励",giveAttachment.nickName,giveAttachment.money];
    
    NSRange range = NSMakeRange(0,giveAttachment.nickName.length);
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:content];
    [strAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xF5B800) range:range];
    [strAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    
    range = NSMakeRange(giveAttachment.nickName.length+1,2);
    [strAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFffff) range:range];
    [strAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    
    range = NSMakeRange(giveAttachment.nickName.length+2+2,giveAttachment.money.length);
    [strAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xF5B800) range:range];
    [strAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    
    range = NSMakeRange(giveAttachment.nickName.length+3+2+giveAttachment.money.length,3);
    [strAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFffff) range:range];
    [strAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    
    self.jlContentLabel.attributedText = strAttr;
    
}

- (IBAction)closeAction:(id)sender {
    [self dismiss];
}


- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.ntesTop += self.ntesHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
