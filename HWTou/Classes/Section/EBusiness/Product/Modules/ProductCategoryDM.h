//
//  ProductCategoryDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/19.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCategoryDM : NSObject

@property (nonatomic, assign) NSInteger mcid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img_url;

@end

@interface ProductCategoryList : ProductCategoryDM

@property (nonatomic, copy) NSArray<ProductCategoryDM *> *children;

@end
