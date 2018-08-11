//
//  ProductCommentListView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/13.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "UITableView+FDTemplateLayoutCell.h"
#import "ProductCommentListView.h"
#import "CommentListCell.h"
#import "PublicHeader.h"

@interface ProductCommentListView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ProductCommentListView

static NSString * const kCellIdentifier = @"comment.CellIdentifier";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[CommentListCell class] forCellReuseIdentifier:kCellIdentifier];
    
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setListData:(NSArray *)listData
{
    _listData = listData;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [tableView fd_heightForCellWithIdentifier:kCellIdentifier cacheByIndexPath:indexPath configuration:^(CommentListCell *cell) {
        [cell setDmComment:self.listData[indexPath.row]];
    }];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell setDmComment:self.listData[indexPath.row]];
    return cell;
}

@end
