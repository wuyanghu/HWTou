//
//  HomeSubCategoryListViewController.h
//  HWTou
//
//  Created by robinson on 2018/1/4.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "ChatClassesModel.h"

@interface HomeSubCategoryListViewController : BaseViewController

@property (nonatomic,assign) BOOL chatScrollStyle;

@property (nonatomic,strong) ChatClassesModel * classModel;
@property (nonatomic,strong) ChatClassSecsModel * secsModel;
@property (nonatomic,assign) NSInteger row;
@end
