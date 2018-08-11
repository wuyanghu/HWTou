//
//  ComCarouselView.h
//  HWTou
//
//  Created by pengpeng on 17/3/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComCarouselView;

@protocol ComCarouselViewDelegate <NSObject>

@optional
- (void)carouselView:(ComCarouselView *)view didSelectItemAtIndex:(NSInteger)index;

- (void)carouselView:(ComCarouselView *)view didScrollToIndex:(NSInteger)index;

@end

// 轮播控件
@interface ComCarouselView : UIView

@property (nonatomic, weak) id<ComCarouselViewDelegate> delegate;

@end

// 图片类型
@interface ComCarouselImageView : ComCarouselView

/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

/** 本地图片数组 */
@property (nonatomic, strong) NSArray *localImageNamesGroup;

/** 是否无限循环,默认Yes */
@property (nonatomic, assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic, assign) BOOL autoScroll;

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;


@end

// 文本类型
@interface ComCarouselLabelView : ComCarouselView

/** 文本内容数组 */
@property (nonatomic, strong) NSArray *titlesGroup;

@end
