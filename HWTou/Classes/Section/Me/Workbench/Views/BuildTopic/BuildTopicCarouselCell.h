//
//  BuildTopicCarouselCell.h
//  HWTou
//
//  Created by robinson on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComCarouselView.h"
#import "CustomButton.h"
#import "TopicWorkDetailModel.h"

//轮播图
@interface BuildTopicCarouselCell : UITableViewCell<ComCarouselViewDelegate>
@property (nonatomic,strong) ComCarouselImageView * vCarouselImg; // 图片轮播
@property (nonatomic,strong) NSArray * vCarouselImgArr;
@end

//录入语音、编辑封面
@interface EnterEditCell:UITableViewCell
@property (nonatomic,strong) UIButton * enterBtn;//录入语音
@property (nonatomic,strong) UIButton * editBtn;//编辑封面

@property (nonatomic,weak) id<TopicButtonSelectedDelegate> btnDelegate;
@end

@interface InputTitleCell:UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong) UITextField * textField;//单行输入框
@end

@interface ShareContentCell:UITableViewCell<UITextViewDelegate>
@property (nonatomic,strong) UITextView * textView;//多行输入框
@end
