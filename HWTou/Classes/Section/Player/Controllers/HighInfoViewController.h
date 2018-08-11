//
//  HighInfoViewController.h
//  HWTou
//
//  Created by robinson on 2018/1/5.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewController.h"
#import "HighInfoPlayInstance.h"

@interface HighInfoViewController : BaseViewController
@property (nonatomic,assign) NSInteger chatId;
@property (nonatomic, assign) BOOL isWorkChat;
@property (nonatomic,strong) HighInfoPlayInstance * playInstance;
@end
