//
//  CommonTableViewController.m
//
//  Created by pengpeng on 15/10/23.
//  Copyright (c) 2015年 PP. All rights reserved.
//

#import "CommonTableViewController.h"
#import "CommonTableViewCell.h"
#import "TableCellGroup.h"
#import "TableCellItem.h"

@interface CommonTableViewController ()

/** UITableView 需要显示的Cell数据模型 */
@property (nonatomic, strong) NSMutableArray    *tableGroups;

@end

@implementation CommonTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
}

- (instancetype)init
{
    // 屏蔽tableView显示的样式
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)setupTableView
{
    // 设置tableView属性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor colorWithWhite:0.88 alpha:1];
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)tableGroups
{
    if (_tableGroups == nil)
    {
        _tableGroups = [NSMutableArray array];
    }
    
    return _tableGroups;
}

#pragma mark - 设置状态栏风格
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 屏幕旋转控制
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 滑动时隐藏键盘
    [self.view endEditing:YES];
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
        
        [self.navigationController pushViewController:viewController animated:YES];
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
