//
//  MuteListViewController.m
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MuteListViewController.h"
#import "MuteRequest.h"
#import "MuteListTableViewCell.h"
#import "PublicHeader.h"

@interface MuteListViewController ()<MuteListTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation MuteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"永久禁言"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MuteListTableViewCell" bundle:nil] forCellReuseIdentifier:[MuteListTableViewCell cellReuseIdentifierInfo]];
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)request{
    [MuteRequest getUserMute:^(AnswerLsArray *response) {
        if (response.status == 200) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:response.data];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - MuteListTableViewCellDelegate

- (void)onMuteAction:(NSDictionary *)itemDict button:(UIButton *)button{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"解封用户" message:@"确定解封该用户吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self onMute:itemDict button:button];
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

- (void)onMute:(NSDictionary *)itemDict button:(UIButton *)button{
    [button setEnabled:NO];
    [button setTitle:@"已解封" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromHex(0x909090) forState:UIControlStateNormal];
    
    MuteUserParam * userParam = [MuteUserParam new];
    userParam.accId = itemDict[@"userId"];
    userParam.flag = 3;
    [MuteRequest muteUser:userParam Success:^(AnswerLsDict *response) {
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MuteListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[MuteListTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    cell.cellDelegate = self;
    [cell setItemDict:self.dataArray[indexPath.row]];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -  getter

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
