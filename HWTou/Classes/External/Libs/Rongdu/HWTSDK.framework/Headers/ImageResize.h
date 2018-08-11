//
//  ImageResize.h
//  
//
//  Created by shen-lf on 13-10-12.
//  Copyright (c) 2013年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage (UIImageExtras)
-(UIImage *)TransformtoSize:(CGSize)Newsize;
//头像
-(UIImage *)IcontoSize:(CGSize)Newsize1;
@end
