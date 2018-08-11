//
//  MediaModel.h
//  HWTou
//
//  Created by 赤 那 on 2017/4/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger,  MediaType){
    
    MediaType_NetworkImg = 0,   // 网络图片
    MediaType_LocalImg,         // 本地图片
    MediaType_Video,            // 视频
    MediaType_Button,           // 创建添加按钮
    
};

@interface MediaModel : UIView

@property (nonatomic, assign) NSInteger id;             // 图片 ID
@property (nonatomic, strong) NSString *img_url;        // 展示图片 Url
@property (nonatomic, assign) NSInteger c_id;           // 课程 ID

/*以下数据为自定义*/
@property (nonatomic, assign) MediaType m_MediaType;
@property (nonatomic, strong) UIImage *m_Image;
@property (nonatomic, strong) PHAsset *m_PhAsset;

@end
