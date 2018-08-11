//
//  ManageAddressView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddressGoodsDM.h"

typedef NS_ENUM(NSInteger, OperationsType){
    
    OperationsType_New = 0,     // 新增
    OperationsType_Modify,      // 修改
    
};

@protocol ManageAddressViewDelegate <NSObject>

- (void)onSelectedRegion;
- (void)onAddAddressSuccess:(AddressGoodsDM *)address;
- (void)onModifyAddressSuccess:(AddressGoodsDM *)address;

@end

@interface ManageAddressView : UIView

@property (nonatomic, weak) id<ManageAddressViewDelegate> m_Delegate;

/**
 *  @brief 编辑地区 调用该方法
 *
 *  @param model    AddressGoodsDM
 *
 */
- (void)setAddressData:(AddressGoodsDM *)model;

/**
 *  @brief 修改地区 调用该方法
 *
 *  @param dic    dic<Province:RegionResult,City:RegionResult,Area:RegionResult>
 *
 */
- (void)updateSelectionArea:(NSDictionary *)dic;

@end
