//
//  InputLocationSelectViewController.h
//  HWTou
//
//  Created by Reyna on 2018/1/23.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

@protocol InputLocationSelectDelegate
- (void)didNotDisplayLocation;//不展示位置
- (void)didSelectLocation:(NSString *)locationName;//选择某个位置
@end

@interface InputLocationSelectViewController : BaseViewController

@property (nonatomic, weak) __weak id<InputLocationSelectDelegate> delegate;

@property (nonatomic, assign) double orderedLat;
@property (nonatomic, assign) double orderedLng;

+ (instancetype)createWithLat:(double)lat lng:(double)lng delegate:(id<InputLocationSelectDelegate>)delegate;

@end
