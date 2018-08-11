//
//  InviteFriendListViewController.m
//  HWTou
//
//  Created by robinson on 2018/1/16.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "InviteFriendListViewController.h"
#import "InviteFrendViewModel.h"
#import "InviteFriendListTableViewCell.h"
#import "PersonHomeReq.h"
#import "PublicHeader.h"

@interface InviteFriendListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) InviteFrendViewModel * inviteViewModel;
@end

@implementation InviteFriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"我的邀请"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InviteFriendListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[InviteFriendListTableViewCell cellReuseIdentifierInfo]];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestInviteList:NO];
    }];
    
    [self requestInviteList:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestInviteList:(BOOL)isRefresh{
    InviteListParam * listParam = self.inviteViewModel.inviteListParam;
    if (isRefresh) {
        listParam.page = 1;
    }else{
        listParam.page ++;
    }
    
    [PersonHomeRequest inviteList:listParam Success:^(CityInfoResponse *response) {
        [self.inviteViewModel bindWithArray:response.data isRefresh:isRefresh];
        [self.tableView reloadData];
        
        if (response.data.count<listParam.pagesize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {

    }];
}

#pragma makrk - uitableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.inviteViewModel.inviteDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    InviteFriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[InviteFriendListTableViewCell cellReuseIdentifierInfo]];
    [cell setFriendModel:self.inviteViewModel.inviteDataArr[indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InviteFrendModel * frendModel = self.inviteViewModel.inviteDataArr[indexPath.row];
    [Navigation showPersonalHomePageViewController:self attendType:dynamicButtonType uid:frendModel.uid];
}

#pragma mark - getter

- (InviteFrendViewModel *)inviteViewModel{
    if (!_inviteViewModel) {
        _inviteViewModel = [[InviteFrendViewModel alloc] init];
    }
    return _inviteViewModel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
