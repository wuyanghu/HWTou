//
//  MsgDetailViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MsgDetailViewController.h"
#import "PublicHeader.h"
#import "MessageReq.h"
#import "MessageDM.h"

@interface MsgDetailViewController ()

@property (nonatomic, strong) UILabel *labContent;

@end

@implementation MsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self markReadStatus];
}

- (void)createUI
{
    self.view.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.labContent = [[UILabel alloc] init];
    self.labContent.textColor = UIColorFromHex(0x333333);
    self.labContent.font = FontPFRegular(15.0f);
    self.labContent.numberOfLines = 0;
    self.labContent.text = self.dmMsg.content;
    
    [self.view addSubview:self.labContent];
    [self.labContent makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.leading.equalTo(15);
        make.trailing.equalTo(self.view).offset(-20);
    }];
}

- (void)setDmMsg:(MessageDM *)dmMsg
{
    _dmMsg = dmMsg;
    self.title = dmMsg.title;
    self.labContent.text = dmMsg.content;
}

- (void)markReadStatus
{
    if (self.dmMsg.status == 0) { // 需要标记已读
        self.dmMsg.status = 1;
        MessageMarkParam *param = [MessageMarkParam new];
        param.muid = self.dmMsg.muid;
        [MessageReq markWithParam:param success:nil failure:nil];
    }
}

@end
