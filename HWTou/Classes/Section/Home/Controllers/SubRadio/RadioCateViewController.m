//
//  RadioCateViewController.m
//  HWTou
//
//  Created by Reyna on 2017/11/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioCateViewController.h"
#import "RadioCateCell.h"
#import "AudioPlayerViewController.h"
#import "RadioRequest.h"
#import "RadioViewModel.h"
#import "PublicHeader.h"

@interface RadioCateViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RadioViewModel *viewModel;
@end

@implementation RadioCateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataRequest:YES];
}

- (void)dataRequest:(BOOL)isRefresh {
    
    if (isRefresh) {
        self.viewModel.page = 1;
    }
    else {
        self.viewModel.page = self.viewModel.page + 1;
    }
    [RadioRequest getRadioDetailWithPage:self.viewModel.page pageSize:self.viewModel.pagesize targetId:self.targetId success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            [self.viewModel bindWithDic:response isRefresh:isRefresh];
            NSLog(@"____%@",response);
            if (_viewModel.dataArr.count > 0) {
                [self.tableView reloadData];
            }
            
            if (!_viewModel.isMoreData) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
        
    } failure:^(NSError *error) {
        
        if (self.tableView.mj_footer.refreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - TableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _viewModel.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioCateCell *cell = [tableView dequeueReusableCellWithIdentifier:[RadioCateCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    
    RadioModel *m = [_viewModel.dataArr objectAtIndex:indexPath.row];
    [cell bind:m];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadioModel *m = [self.viewModel.dataArr objectAtIndex:indexPath.row];
    
    [Navigation showAudioPlayerViewController:self radioModel:m];
}

#pragma mark - Get

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"RadioCateCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[RadioCateCell cellReuseIdentifierInfo]];
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf dataRequest:NO];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (RadioViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[RadioViewModel alloc] init];
        _viewModel.page = 1;
        _viewModel.pagesize = 10;
    }
    return _viewModel;
}
    
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
