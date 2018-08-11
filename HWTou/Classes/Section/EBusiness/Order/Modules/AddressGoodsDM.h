//
//  AddressGoodsDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/3/30.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressGoodsDM : NSObject

@property (nonatomic, assign) NSInteger maid;           // 收货人地址编号
@property (nonatomic, assign) NSInteger p_id;           // 省地区编号
@property (nonatomic, assign) NSInteger city_id;        // 市地区编号
@property (nonatomic, assign) NSInteger d_id;           // 区地区编号
@property (nonatomic, strong) NSString *name;           // 收货人姓名
@property (nonatomic, strong) NSString *tel;            // 收货人电话
@property (nonatomic, strong) NSString *address;        // 收货地址
@property (nonatomic, strong) NSString *full_name;      // 收货地址详情 省+市+区+address
@property (nonatomic, assign) NSInteger is_top;         // 是否默认 1：默认,0:非默认
@property (nonatomic, strong) NSString *post_code;      // 邮编   Null或者有效值
@property (nonatomic, strong) NSString *pname;          // 省名称
@property (nonatomic, strong) NSString *cname;          // 城市名称
@property (nonatomic, strong) NSString *dname;          // 区域名称

@end
