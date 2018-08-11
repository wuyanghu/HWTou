//
//  BasisUITool.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/20.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoadDataType){
    
    LoadDataType_New = 0,            // 刷新数据
    LoadDataType_More = 1,           // 加载更多
    LoadDataType_Default,            // 默认
    
};

@interface BasisUITool : NSObject

/**
 *  @brief Label
 *
 *  @param textColor    字体颜色
 *  @param size         字体大小
 *
 *  @return UILabel
 */
+ (UILabel *)getLabelWithTextColor:(UIColor *)textColor size:(CGFloat)size;

/**
 *  @brief Label (Bold)
 *
 *  @param textColor        字体颜色
 *  @param size             字体大小
 *
 *  @return UILabel
 */
+ (UILabel *)getBoldLabelWithTextColor:(UIColor *)textColor size:(CGFloat)size;

/**
 *  @brief Button
 *
 *  @param target           响应层
 *  @param actionMethod     事件
 *
 *  @return UIButton
 */
+ (UIButton *)getBtnWithTarget:(id)target action:(SEL)actionMethod;
//正常按钮，不带圆角
+ (UIButton *)getNormalBtnWithTarget:(id)target action:(SEL)actionMethod;
/**
 *  @brief ImageView
 *
 *  @param imageName        图片名称
 *  @param isEnabled        是否可交互
 *
 *  @return UIImageView
 */
+ (UIImageView *)getImageViewWithImage:(NSString *)imageName withIsUserInteraction:(BOOL)isEnabled;

/**
 *  @brief TextField
 *
 *  @param textColor        字体颜色
 *  @param size             字体大小
 *  @param placeholder      默认显示内容
 *  @param delegate         委托
 *
 *  @return UITextField
 */
+ (UITextField *)getTextFieldWithTextColor:(UIColor *)textColor withSize:(CGFloat)size
                           withPlaceholder:(NSString *)placeholder withDelegate:(id)delegate;

+ (UITextView *)getTextViewWithTextColor:(UIColor *)textColor withSize:(CGFloat)size
                         withPlaceholder:(NSString *)placeholder withDelegate:(id)delegate;
/**
 *  @brief TextField (Bold)
 *
 *  @param textColor        字体颜色
 *  @param size             字体大小
 *  @param placeholder      默认显示内容
 *  @param delegate         委托
 *
 *  @return UITextField
 */
+ (UITextField *)getBoldTextFieldWithTextColor:(UIColor *)textColor withSize:(CGFloat)size
                               withPlaceholder:(NSString *)placeholder withDelegate:(id)delegate;

/**
 *  @brief TableView
 *
 *  @param frame            CGRect
 *  @param style            UITableViewStyle
 *  @param delegate         UITableViewDelegate
 *  @param dataSource       UITableViewDataSource
 *  @param isScrollEnabled  滚动 YES 启用，NO 禁用
 *  @param separatorStyle   UITableViewCellSeparatorStyle
 *
 *  @return UITableView
 */
+ (UITableView *)getTableViewWithFrame:(CGRect)frame
                                 style:(UITableViewStyle)style
                              delegate:(id)delegate
                            dataSource:(id)dataSource
                         scrollEnabled:(BOOL)isScrollEnabled
                        separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle;

/**
 *  @brief 字符串尺寸计算
 *
 *  @param content          字符串
 *  @param font             UIFont
 *
 *  @return CGSize
 */
+ (CGSize)calculateSize:(NSString *)content font:(UIFont *)font;

/**
 *  @brief 图片加载处理
 *
 *  @param imgView          需要设置的 UIImageView
 *  @param imgUrl           图片名称 或 图片路径 或 Url
 *  @param defaultImg       默认加载图片
 *
 */
+ (void)imgLoadingProcessing:(UIImageView *)imgView imgUrl:(id)imgUrl
            placeholderImage:(UIImage *)defaultImg;

/**
 *  头像圆处理
 *
 *  @param center 宽 高
 *
 *  @return CAShapeLayer
 */
+ (CAShapeLayer *)headPortraitRoundProcessing:(CGFloat)center;

/**
 *  获取指定宽度的字符串在 UITextView/UILabel 上的高度
 *
 *  @param object   待计算的 UITextView/UILabel
 *  @param width    限制字符串显示区域的宽度
 *
 *  @return 高度
 *
 */
+ (CGFloat)heightForString:(NSObject *)object andWidth:(CGFloat)width;

@end
