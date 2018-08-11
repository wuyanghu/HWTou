//
//  ConsumpGoldDetailDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/7/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsumpGoldDetailDM : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *tname;

@property (nonatomic, copy) NSString *acct_name;
@property (nonatomic, copy) NSString *card_no;
@property (nonatomic, copy) NSString *money_order;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, assign) NSInteger type;

@end
