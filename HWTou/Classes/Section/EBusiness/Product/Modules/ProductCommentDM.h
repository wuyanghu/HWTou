//
//  ProductCommentDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentImageDM : NSObject

@property (nonatomic, copy) NSString *img_url;

@end

@interface ProductCommentDM : NSObject

@property (nonatomic, assign) NSInteger commet_id;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *head_url;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSArray *imgs;

@end
