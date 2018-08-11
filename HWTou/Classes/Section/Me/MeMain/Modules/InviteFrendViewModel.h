//
//  InviteFrendViewModel.h
//  HWTou
//
//  Created by robinson on 2018/1/16.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "PersonHomeReq.h"
#import "InviteFrendModel.h"

@interface InviteFrendViewModel : BaseViewModel
@property (nonatomic,strong) NSMutableArray<InviteFrendModel *> * inviteDataArr;
@property (nonatomic,strong) InviteListParam * inviteListParam;

- (void)bindWithArray:(NSArray *)array isRefresh:(BOOL)isRefresh;
@end
