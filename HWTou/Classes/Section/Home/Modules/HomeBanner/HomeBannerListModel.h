//
//  HomeBannerListModel.h
//  HWTou
//
//  Created by robinson on 2017/12/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface HomeBannerListModel : BaseModel
@property (nonatomic,assign) NSInteger bannerId;//
@property (nonatomic,copy) NSString * bannerImg;//banner图片路径
@property (nonatomic,copy) NSString * title;//banner标题
@property (nonatomic,assign) NSInteger status;//显示状态
@property (nonatomic,assign) NSInteger rank;//排序值
@property (nonatomic,assign) NSInteger clickType;//点击效果 0：无点击相关，1：图文内容，2：链接，3：广播详情，4：广播标签，5：聊吧详情，6：聊吧标签，7：话题详情，8：话题标签，9：商品详情，10：商品分类，99：其他
@property (nonatomic,copy) NSString * linkUrl;// 链接地址
@property (nonatomic,assign) NSInteger lookNum;//查看数
@property (nonatomic,assign) NSInteger rtcId;//广播，话题，聊吧ID
@property (nonatomic,assign) NSInteger shopId;//商品ID
@property (nonatomic,assign) NSInteger bannerType;//banner类型：1:热门banner,2：话题banner
@property (nonatomic,assign) NSInteger labelId;//标签ID
@property (nonatomic,copy) NSString * imgText;//图文内容
@end
