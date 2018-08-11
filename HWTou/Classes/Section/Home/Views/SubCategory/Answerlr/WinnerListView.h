//
//  WinnerListView.h
//  HWTou
//
//  Created by robinson on 2018/2/2.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetWinUserModel.h"

@interface WinnerListView : UIView
@property (weak, nonatomic) IBOutlet UILabel *winnerNum;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *getMoneyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView2;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel2;
@property (weak, nonatomic) IBOutlet UILabel *getMoneyLabel2;

@property (nonatomic,strong) GetWinUserModel * userModel;
@end
