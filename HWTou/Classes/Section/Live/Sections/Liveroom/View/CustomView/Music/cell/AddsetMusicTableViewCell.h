//
//  AddsetMusicTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol AddsetMusicTableViewCellDelegate
- (void)downLoadAction:(NSDictionary *)itemDict;
@end

@interface AddsetMusicTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *downMusicBtn;

@property (nonatomic,strong) NSDictionary * itemDict;
@property (nonatomic,weak) id<AddsetMusicTableViewCellDelegate> cellDelegate;
@end
