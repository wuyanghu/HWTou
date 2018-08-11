//
//  ActivityNewsDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityNewsDM : NSObject

@property (nonatomic, assign) NSInteger news_id;        // 新闻编号
@property (nonatomic, assign) NSInteger type;           // 文章类型(0:外部链接,1:模板)
@property (nonatomic, assign) NSInteger read_num;       // 阅读量
@property (nonatomic, assign) NSInteger alike_num;      // 点赞量
@property (nonatomic, assign) BOOL collected_flag;      // 是否收藏
@property (nonatomic, copy) NSString *title;            // 标题
@property (nonatomic, copy) NSString *remark;           // 标题描述
@property (nonatomic, copy) NSString *link;             // 点击链接
@property (nonatomic, copy) NSString *img_url;          // 展示图片

@end

@interface ActivityCategoryDM : NSObject

@property (nonatomic, assign) NSInteger ncid;           // 编号
@property (nonatomic, copy) NSString *name;             // 标题
@property (nonatomic, copy) NSString *img_url;          // 展示图片

@end
