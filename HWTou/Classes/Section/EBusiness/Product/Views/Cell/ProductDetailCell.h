//
//  ProductDetailCell.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductDetailDM;

@interface ProductDetailCell : UITableViewCell

@end

@interface ProductBasisInfoCell : ProductDetailCell

@property (nonatomic, strong) ProductDetailDM *dmProduct;

@end

@interface ProductDetailAttCell : ProductDetailCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger number;

@end

@interface ProductCommentAllCell : ProductDetailCell

@end
