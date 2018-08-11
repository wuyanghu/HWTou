//
//  ProductCommentViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductCommentViewController.h"
#import "ProductCommentView.h"
#import "PublicHeader.h"

@interface ProductCommentViewController ()

@property (nonatomic, strong) ProductCommentView *vComment;

@end

@implementation ProductCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.title = @"评价";
    self.vComment = [[ProductCommentView alloc] init];
    self.vComment.listData = self.listData;
    self.vComment.mpid = self.mpid;
    [self.view addSubview:self.vComment];
    
    [self.vComment makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
@end
