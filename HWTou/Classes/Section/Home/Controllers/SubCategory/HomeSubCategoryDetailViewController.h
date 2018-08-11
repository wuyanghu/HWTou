//
//  HomeSubCategoryDetailViewController.h
//  HWTou
//
//  Created by robinson on 2018/1/4.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "ChatClassesModel.h"
@class GuessULikeModel;

typedef void(^HomeSubCategoryDetailBlock)(GuessULikeModel * model);

@interface HomeSubCategoryDetailViewController : BaseViewController
@property (nonatomic,assign) NSInteger classId;
@property (nonatomic,copy) HomeSubCategoryDetailBlock detailBlock;
@end
