//
//  InvestActivityDM.h
//  HWTou
//
//  Created by 彭鹏 on 2017/8/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvestActivityDM : NSObject

@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *images;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *t_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tname;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, assign) NSInteger classify; // 0: 普通标 4: 体验标

@end
