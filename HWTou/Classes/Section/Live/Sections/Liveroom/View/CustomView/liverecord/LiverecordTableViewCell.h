//
//  LiverecordTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"

@class GetChatRecordsModel;

@interface LiverecordTableViewCell : BaseTableViewCell
@property (nonatomic,strong) GetChatRecordsModel * recordsModel;
@end
