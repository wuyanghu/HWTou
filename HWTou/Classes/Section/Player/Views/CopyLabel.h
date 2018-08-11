//
//  CopyLabel.h
//  HWTou
//
//  Created by robinson on 2018/1/15.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CopyLabelStatus) {
    COPY_PASTE_LABEL,  //有复制和粘贴功能label
    COPY_LABEL //只有复制功能label
};

@interface CopyLabel : UILabel
//创建Label时可根据不同的类型来实现不同的功能
@property (nonatomic, assign) CopyLabelStatus labelType;
@end  
