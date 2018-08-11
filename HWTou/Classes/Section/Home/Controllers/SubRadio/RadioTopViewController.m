//
//  RadioTopViewController.m
//  HWTou
//
//  Created by Reyna on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "RadioTopViewController.h"
#import "RadioTopHeaderCell.h"
#import "RadioTopCell.h"
#import "AudioPlayerViewController.h"
#import "RadioRequest.h"
#import "RadioViewModel.h"
#import "PublicHeader.h"
#import "TopNavBarView.h"

@interface RadioTopViewController () <TopNavBarDelegate, RadioTopHeaderDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) TopNavBarView *navBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RadioViewModel *viewModel;

@end

@implementation RadioTopViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBar.delegate = self;
    [self dataRequest];
}

- (void)dataRequest {
    
    [RadioRequest getRadioDetailTopWithSuccess:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            [self.viewModel bindWithDic:response];
            NSLog(@"____%@",response);
            if (_viewModel.dataArr.count > 0) {
                [self.tableView reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - TableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return _viewModel.dataArr.count > 2 ? _viewModel.dataArr.count - 3 : 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RadioTopHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:[RadioTopHeaderCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        [cell bind:self.viewModel];
        cell.delegate = self;
        return cell;
    }
    RadioTopCell *cell = [tableView dequeueReusableCellWithIdentifier:[RadioTopCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    
    RadioModel *m = [_viewModel.dataArr objectAtIndex:indexPath.row + 3];
    [cell bind:m];
    cell.topPlaceLab.text = [NSString stringWithFormat:@"%ld",indexPath.row + 4];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [RadioTopHeaderCell cellRatioHeight];
    }
    return [RadioTopCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return;
    }
    RadioModel *m = [self.viewModel.dataArr objectAtIndex:indexPath.row + 3];
    
    [Navigation showAudioPlayerViewController:self radioModel:m];
}

#pragma mark - TopNavBarDelegate

- (void)topNavBackBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RadioTopHeaderDelegate

- (void)topSelectBtnAction:(NSInteger)index {
    RadioModel *m = [self.viewModel.dataArr objectAtIndex:index];
    
    [Navigation showAudioPlayerViewController:self radioModel:m];
}

#pragma mark - Get

- (TopNavBarView *)navBar {
    if (!_navBar) {
        _navBar = [[TopNavBarView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64) type:0];
        [self.view addSubview:_navBar];
    }
    return _navBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
#ifdef __IPHONE_11_0
        if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        [_tableView registerNib:[UINib nibWithNibName:@"RadioTopCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[RadioTopCell cellReuseIdentifierInfo]];
        [_tableView registerNib:[UINib nibWithNibName:@"RadioTopHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[RadioTopHeaderCell cellReuseIdentifierInfo]];
        [self.view addSubview:_tableView];
        [self.view bringSubviewToFront:self.navBar];
    }
    return _tableView;
}

- (RadioViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[RadioViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
