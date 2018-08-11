//
//  ProductCommentCell.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/18.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderProductDM;
@class ProductCommentCell;

#define kImageNumMax            6
#define kNumberRows             3

@protocol ProductCommentDelegate <NSObject>


/**
 点击上传图片按事件

 @param cell 当前cell
 */
- (void)cellCommentActionUpload:(ProductCommentCell *)cell;


/**
 点击评论图片

 @param cell 当前cell
 @param index 图片位置
 */
- (void)cellComment:(ProductCommentCell *)cell didSelectIndex:(NSInteger)index;

/**
 评论内容改变
 
 @param cell 当前cell
 @param content 评论内容
 */
- (void)cellComment:(ProductCommentCell *)cell contentChange:(NSString *)content;

@end

@interface ProductCommentCell : UITableViewCell

@property (nonatomic, weak) id<ProductCommentDelegate> delegate;
@property (nonatomic, strong) OrderProductDM *dmProduct;
@property (nonatomic, copy) NSArray *images;   // 图片文件
@property (nonatomic, copy) NSString *content;

- (CGFloat)heightForCellWithImgCount:(NSInteger)imgCount;

@end
