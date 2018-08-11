//
//  ChatClassesModel.h
//  HWTou
//
//  Created by robinson on 2018/1/3.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface ChatClassSecsModel:BaseModel
@property (nonatomic,assign) NSInteger classIdSec;//二级分类ID
@property (nonatomic,copy) NSString * classNameSec;//二级分类名字
@end

@interface ChatClassesModel : BaseModel
@property (nonatomic,copy) NSString * iconImg;//分类图标
@property (nonatomic,assign) NSInteger classId;//分类ID
@property (nonatomic,copy) NSString * className;//分类名
@property (nonatomic,assign) NSInteger flag;//1:热门分类，0：其他分类

@property (nonatomic,assign) BOOL isShowAll;//是否显示
@property (nonatomic,strong) NSMutableArray<ChatClassSecsModel *> * chatClassSecsArr;//二级分类集合
@property (nonatomic,strong) NSMutableArray<ChatClassSecsModel *> * showArr;//二级分类集合
@end
