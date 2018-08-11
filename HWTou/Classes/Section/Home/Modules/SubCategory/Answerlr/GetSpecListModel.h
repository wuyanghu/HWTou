//
//  GetSpecListModel.h
//  HWTou
//
//  Created by robinson on 2018/2/1.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface GetSpecListModel : BaseModel
@property (nonatomic,assign) NSInteger specId;//专场ID
@property (nonatomic,copy) NSString * name;//专场名称
@property (nonatomic,copy) NSString * coverUrl;//封面图url
@property (nonatomic,copy) NSString * bgmUrl;//背景图url
@end
