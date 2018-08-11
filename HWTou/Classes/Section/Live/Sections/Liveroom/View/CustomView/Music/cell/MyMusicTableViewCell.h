//
//  MyMusicTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AddSetMusicViewProtocol.h"

@interface MyMusicTableViewCell : BaseTableViewCell
@property (nonatomic,strong) NSDictionary * itemDict;
@property (nonatomic,weak) id<MyMusicTableViewCellDelegate> cellDelegate;
@end
