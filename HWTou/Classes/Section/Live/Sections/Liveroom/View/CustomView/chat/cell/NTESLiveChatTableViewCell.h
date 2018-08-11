//
//  NTESLiveChatTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/3/28.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NTESMessageModel.h"

@protocol NTESLiveChatTextCellDelegate
- (void)longGesturePress:(NTESMessageModel *)model;
- (void)headerAction:(NTESMessageModel *)model;
- (void)doTap:(UITapGestureRecognizer*)recognizer;
@end


@interface NTESLiveChatTableViewCell : BaseTableViewCell
@property (nonatomic,weak) id<NTESLiveChatTextCellDelegate> cellDelegate;

- (void)refresh:(NTESMessageModel *)model;
@end
