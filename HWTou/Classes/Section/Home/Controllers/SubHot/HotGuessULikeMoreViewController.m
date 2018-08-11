//
//  HotMoreViewController.m
//  HWTou
//
//  Created by robinson on 2017/12/12.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HotGuessULikeMoreViewController.h"
#import "HotMoreTableViewCell.h"
#import "PublicHeader.h"
#import "RotRequest.h"
#import "GuessULikeViewModel.h"

#define identifity @"identifity"

@interface HotGuessULikeMoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) GuessULikeViewModel * viewModel;
@end

@implementation HotGuessULikeMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"猜你喜欢"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    GuessULikeParam * ulikeParam = [GuessULikeParam new];
    ulikeParam.page = 6;
    [RotRequest guessULike:ulikeParam Success:^(ArrayResponse *response) {
        [self.viewModel bindWithGuessULike:response.data isRefresh:YES];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.likeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotMoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifity forIndexPath:indexPath];
    [cell setUlistModel:self.viewModel.likeArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Navigation showAudioPlayerViewController:self radioModel:self.viewModel.likeArray[indexPath.row]];
}

#pragma mark - getter

- (GuessULikeViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[GuessULikeViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStylePlain delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView registerClass:[HotMoreTableViewCell class] forCellReuseIdentifier:identifity];
    }
    return _tableView;
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
