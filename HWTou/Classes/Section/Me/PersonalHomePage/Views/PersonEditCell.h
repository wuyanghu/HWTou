//
//  PersonEditCell.h
//  HWTou
//
//  Created by robinson on 2017/12/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonHomeDM.h"

#define my_btn_add_1 @"my_btn_add_1"
#define my_btn_mkf_click @"my_btn_mkf_click"
#define my_btn_mkf_default @"my_btn_mkf_default"

@interface PersonEditCell : UIView

@end


@interface PersonCollectViewHeader:UICollectionReusableView

@end

#pragma mark -
#pragma mark -
#pragma mark - CollectionViewCell
//collectViewCell基类
@interface BaseCollectViewCell:UICollectionViewCell<UITextViewDelegate,UITextViewDelegate>
@property (nonatomic,strong) UIImageView * imageView;

@property (nonatomic,strong) UILabel * titleLabel;//标题
@property (nonatomic,strong) UILabel * subTitleLabel;//副标题
@property (nonatomic,strong) UITextField * textField;//单行输入框

@property (nonatomic,strong) UIButton * introduceBtn;//点击

@property (nonatomic,strong) UITextView * textView;//多行输入框

@property (nonatomic,strong) PersonHomeDM * personHomeModel;
- (void)setCellRow:(NSInteger)cellRow personHomeModel:(PersonHomeDM *)personHomeModel;
@end
//介绍
@interface PersonEditIntroduceCell:BaseCollectViewCell
@end
//签名
@interface PersonEditSignCell:BaseCollectViewCell<UITextViewDelegate>
@end
//昵称
@interface PersonEditNicknameCell:BaseCollectViewCell<UITextFieldDelegate>
@end
//性别、城市
@interface PersonEditSexCityCell:BaseCollectViewCell
@end
//头像、背景图
@interface PersonEditImgCell:BaseCollectViewCell
@property (nonatomic, strong) UIImageView *headerImageView;
@end

@interface PersonEditDataAddCell:BaseCollectViewCell
@end
