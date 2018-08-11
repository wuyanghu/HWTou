//
//  PersonTextView.h
//  HWTou
//
//  Created by robinson on 2017/12/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonTextView : UITextView
/** 占位文字 */
@property (nonatomic,copy) NSString *placeholder;
/** 文字颜色 */
@property (nonatomic,strong) UIColor *placeholderColor;
@end
