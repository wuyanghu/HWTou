//
//  ProductCommentDM.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCommentDM.h"

@implementation CommentImageDM

@end

@implementation ProductCommentDM

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"imgs" : [CommentImageDM class]};
}

@end
