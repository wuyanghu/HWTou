//
//  ComFloorDM.h
//  HWTou
//
//  Created by pengpeng on 17/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FloorEventNomal,    // 无效果
    FloorEventNews,     // 文章详情
    FloorEventProduct,  // 商品详情
    FloorEventLink,     // 跳转链接
    FloorEventParam,     // 跳转链接 传入model
    FloorEventMall,     // 商城主页
    FloorEventInvest,   // 投资主页
    FloorEventNewsCate, // 文章分类
    FloorEventCalabash, // 乐葫芦
    FloorEventActivity, // 活动页面
    FloorEventSigin,    // 签到页面
    FloorEventProduct1, // 商品一级分类
    FloorEventProduct2, // 商品二级分类
} FloorEventType;

@interface FloorItemDM : NSObject

@property (nonatomic, assign) FloorEventType type;
@property (nonatomic, assign) NSInteger fid_id;
@property (nonatomic, copy  ) NSString  *title;
@property (nonatomic, copy  ) NSString  *img_url;
@property (nonatomic, copy  ) NSString  *param;
@property (nonatomic, copy  ) NSString  *ext;

@end

@interface FloorDataDM : NSObject

@property (nonatomic, assign) NSInteger room_id;
@property (nonatomic, assign) NSInteger sequence; // 1:左 2:右
@property (nonatomic, copy  ) NSString  *title;
@property (nonatomic, copy  ) NSString  *img_url;
@property (nonatomic, copy  ) NSArray   *floorItems;

@end

@interface FloorInfoDM : NSObject

@property (nonatomic, assign) NSInteger floor;
@property (nonatomic, assign) NSInteger type; // 1:单图 2:双图
@property (nonatomic, copy  ) NSArray   *floor_data;

@end

@interface FloorListDM : NSObject

@property (nonatomic, assign) NSInteger     list_id;
@property (nonatomic, copy  ) NSString      *title;
@property (nonatomic, copy  ) NSArray       *floor_info;

@end
