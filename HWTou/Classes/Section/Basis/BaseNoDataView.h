//
//  BaseNoDataView.h
//  HWTou
//
//  Created by Reyna on 2017/11/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NoDataViewType) {
    
    NoDataViewTypeContent      = 0,//聊吧消息列表、历史收听列表
    NoDataViewTypeNetworking   = 1,//网络断开
    NoDataViewTypeSearch       = 3,//搜索无数据
    NoDataViewTypeMessage      = 4,//消息中心无数据
    NoDataViewTypeCommunity    = 5,//广播、话题、聊吧互动区
    
};

@interface BaseNoDataView : UIView

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *msgLabel;

- (instancetype)initWithFrame:(CGRect)frame type:(NoDataViewType)type;

@end
