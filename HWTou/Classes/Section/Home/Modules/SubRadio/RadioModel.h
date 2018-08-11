//
//  RadioModel.h
//  HWTou
//
//  Created by Reyna on 2017/11/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseModel.h"

@interface RadioModel : BaseModel

@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, copy) NSString *channelImg;
@property (nonatomic, copy) NSString *playing;

@property (nonatomic, copy) NSString *targetID;
@property (nonatomic, assign) int look;
@property (nonatomic, assign) int channelId;
@property (nonatomic, assign) int radioId;
@property (nonatomic, assign) int isRed;

//扩展
@property (nonatomic, assign) NSInteger topPlace;

@end
