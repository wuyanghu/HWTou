//
//  NTESLiveChatSystemTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/8.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface NTESLiveChatSystemTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *systemLabel;

@property (nonatomic,copy) NSString * content;
@end
