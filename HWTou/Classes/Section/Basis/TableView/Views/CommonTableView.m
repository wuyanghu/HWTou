//
//  CommonTableView.m
//  HWTou
//
//  Created by pengpeng on 17/3/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "UIApplication+Extension.h"
#import "CommonTableViewCell.h"
#import "CommonTableView.h"
#import "CommonTable.h"

@interface CommonTableView () <UITableViewDelegate, UITableViewDataSource>

/** UITableView 需要显示的Cell数据模型 */
@property (nonatomic, strong) NSMutableArray<TableCellGroup *> *tableGroups;

@end

@implementation CommonTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        [self setupTableView];
    }
    return self;
}

- (void)setupTableView
{
    // 设置tableView属性
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorColor = [UIColor colorWithWhite:0.88 alpha:1];
    self.sectionHeaderHeight = 0;
    self.sectionFooterHeight = 0;
    self.dataSource = self;
    self.delegate = self;
}

- (NSMutableArray<TableCellGroup *> *)tableGroups
{
    if (_tableGroups == nil) {
        _tableGroups = [NSMutableArray array];
    }
    return _tableGroups;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 滑动时隐藏键盘
    [self endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TableCellGroup *tableGroup = [self.tableGroups objectAtIndex:section];
    return tableGroup.cellItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableCellGroup *tableGroup = [self.tableGroups objectAtIndex:indexPath.section];
    TableCellItem *cellItem = [tableGroup.cellItems objectAtIndex:indexPath.row];
    
    CommonTableViewCell *cell = [CommonTableViewCell cellWithTableView:tableView cellItem:cellItem];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    TableCellGroup *tableGroup = self.tableGroups[section];
    return tableGroup.footer;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TableCellGroup *tableGroup = self.tableGroups[section];
    return tableGroup.header;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TableCellGroup *tableGroup = [self.tableGroups objectAtIndex:indexPath.section];
    TableCellItem *cellItem = [tableGroup.cellItems objectAtIndex:indexPath.row];
    
    // 跳转到指定的目标控制器
    if (cellItem.destViewController != nil)
    {
        UIViewController *viewController = [[cellItem.destViewController alloc] init];
        viewController.title = cellItem.title;
        
        [[UIApplication topViewController].navigationController pushViewController:viewController animated:YES];
    }
    
    // 执行block
    if (cellItem.cellDidSelectHandle)
    {
        cellItem.cellDidSelectHandle();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableCellGroup *tableGroup = [self.tableGroups objectAtIndex:indexPath.section];
    TableCellItem *cellItem = [tableGroup.cellItems objectAtIndex:indexPath.row];
    return cellItem.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    TableCellGroup *tableGroup = self.tableGroups[section];
    if (section == 0 && tableGroup.headerHeight == 0)
    {
        return CGFLOAT_MIN;
    }
    
    return tableGroup.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    TableCellGroup *tableGroup = self.tableGroups[section];
    return tableGroup.footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TableCellGroup *tableGroup = self.tableGroups[section];
    return tableGroup.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    TableCellGroup *tableGroup = self.tableGroups[section];
    return tableGroup.footerView;
}
@end
