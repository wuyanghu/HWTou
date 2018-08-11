//
//  UIBarButtonItem+Extension.m
//
//  Created by PP on 15/10/23.
//  Copyright (c) 2016年 PP. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)image hltImageName:(NSString *)hltImage
                                target:(id)target action:(SEL)action{
    
    UIButton *button = [[UIButton alloc] init];
    
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    if (hltImage) {
        
        [button setImage:[UIImage imageNamed:hltImage] forState:UIControlStateHighlighted];
    }
    
    // 按钮大小默认为图片大小
    //CGRect rect = {0, 0, button.currentBackgroundImage.size.width+5,button.currentBackgroundImage.size.height+5};
    CGRect rect = CGRectMake(0, 0, 25, 25);
    [button setFrame:rect];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title withColor:(UIColor *)textColor
                            target:(id)target action:(SEL)action{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    
    NSDictionary *dictAttributes = @{NSFontAttributeName : button.titleLabel.font};
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:dictAttributes];
    
    CGRect rect = {0, 0, titleSize};
    [button setFrame:rect];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

@end
