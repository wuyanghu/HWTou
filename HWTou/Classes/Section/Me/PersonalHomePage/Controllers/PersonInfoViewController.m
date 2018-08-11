//
//  PersonInfoViewController.m
//  HWTou
//
//  Created by robinson on 2017/11/15.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "PersonInfoCell.h"
#import "PublicHeader.h"
#import "PersonalAttendViewController.h"

@interface PersonInfoViewController ()<PersonInfoViewDelegate>

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.personHomePageView.frame.size.height, 0, 0, 0);
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.personHomePageView.frame.size.height)];
    self.tableView.tableHeaderView = tableHeaderView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.personHomePageView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonInfoCell * cell = [self.tableView dequeueReusableCellWithIdentifier:[PersonInfoCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    cell.infoViewDelegate = self;
    [cell setPersonHomeModel:_personHomeModel];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)attendViewTapDelegate:(UITapGestureRecognizer *)attendViewTap{
    [_personInfoDelegate jumpVcDelegate];
}

- (void)setPersonHomeModel:(PersonHomeDM *)personHomeModel{
    _personHomeModel = personHomeModel;
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.personHomePageView.frame;
    CGFloat placeHolderHeight = frame.size.height - 40;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0 && offsetY <= placeHolderHeight) {
        frame.origin.y = -offsetY;
    } else if (offsetY > placeHolderHeight) {
        frame.origin.y = - placeHolderHeight;
    } else if (offsetY <0) {
        frame.origin.y =  - offsetY;
    }
    self.personHomePageView.frame = frame;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStyleGrouped delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[PersonInfoCell class] forCellReuseIdentifier:[PersonInfoCell cellReuseIdentifierInfo]];
       
        _tableView.estimatedRowHeight = 300;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

@end
