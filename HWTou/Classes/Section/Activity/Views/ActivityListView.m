//
//  ActivityListView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/6.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityListView.h"
#import "ActivityListCell.h"
#import "ActivityListDM.h"
#import "PublicHeader.h"

@interface ActivityListView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ActivityListView

static  NSString * const kCellIdentifier = @"CellIdentifier";

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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.tableView.rowHeight = 0.5 * kMainScreenWidth;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ActivityListCell class] forCellReuseIdentifier:kCellIdentifier];
    
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *items = [self.listData objectAtIndex:section];
    return items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *items = [self.listData objectAtIndex:section];
    if (items.count > 0) {
        return 35.0f;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    NSArray *items = [self.listData objectAtIndex:indexPath.section];
    ActivityListDM *dmList = items[indexPath.row];
    [cell setDmList:dmList];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *items = [self.listData objectAtIndex:section];
    ActivityListDM *dmList = items.firstObject;
    switch (dmList.type) {
        case 1:
            return @"进行中";
        case 2:
            return @"往期活动";
        case 3:
            return @"未开始";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *items = [self.listData objectAtIndex:indexPath.section];
    ActivityListDM *dmList = items[indexPath.row];
    
    ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc] init];
    detailVC.dmActivity = dmList;
    [[UIApplication topViewController].navigationController pushViewController:detailVC animated:YES];
}

- (void)reloadTableData
{
    [self.tableView reloadData];
}
@end
