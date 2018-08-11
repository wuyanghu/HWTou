//
//  CodePopView.h
//  HWTou
//  验证码弹窗
//  Created by robinson on 2017/11/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ButtonClickTag){
    closeButtonClickTag,//关闭
    sureButtonClickTag,//确定
    switchButtonClickTag,//换一张
};

@protocol CodePopViewDelegate <NSObject>
- (void)buttonClick:(ButtonClickTag)tag;
@end

@interface CodePopView : UIView

@property (nonatomic,weak) id<CodePopViewDelegate> m_codePopViewDelegate;
@property (nonatomic,strong) UITextField *accTF;//验证码

- (BOOL)isCodeVaild;//验证码是否有效
- (void)actionImageCode;//获取验证码
- (void)showCodePopView;//弹出框
- (void)colseCodePopView;//关闭框
@end
