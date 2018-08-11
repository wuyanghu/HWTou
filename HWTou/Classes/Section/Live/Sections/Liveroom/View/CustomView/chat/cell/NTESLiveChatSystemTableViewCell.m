//
//  NTESLiveChatSystemTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/4/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "NTESLiveChatSystemTableViewCell.h"

@implementation NTESLiveChatSystemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(NSString *)content{
    _content = content;
    [self setSystemLabelText:[NSString stringWithFormat:@"系统通知:%@",content]];
}

- (void)setSystemLabelText:(NSString *)strContent{
    
    NSRange range = NSMakeRange(0,5);
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:strContent];
    [strAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFE486) range:range];
    [strAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    
    range = NSMakeRange(5,strContent.length-5);
    [strAttr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF85C6A3) range:range];
    [strAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    
    self.systemLabel.attributedText = strAttr;
    
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"NTESLiveChatSystemTableViewCell";
}

@end
