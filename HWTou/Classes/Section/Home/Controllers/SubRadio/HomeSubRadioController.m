//
//  HomeSubRadioController.m
//  HWTou
//
//  Created by Reyna on 2017/11/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeSubRadioController.h"
#import "AudioPlayerViewController.h"
#import "BaseBannerCell.h"
#import "RadioHeaderCell.h"
#import "RadioTypeCell.h"
#import "RadioCateCell.h"
#import "RadioClassViewModel.h"
#import "RadioRequest.h"
#import "RadioViewModel.h"
#import "PublicHeader.h"
#import "RadioCateViewController.h"
#import "RadioTopViewController.h"
#import "HomeRadioSignModel.h"
#import "HomeRadioSignTopView.h"

@interface HomeSubRadioController () <UITableViewDataSource, UITableViewDelegate, RadioHeaderTypeDelegate, RadioClassTypeDelegate, HomeRadioSignTopViewDelegate>
{
    RadioClassModel * _radioClassModel;
}
@property (nonatomic, strong) HomeRadioSignTopView *radioSignTopView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *signRadioArray;
@property (nonatomic, strong) RadioClassViewModel *radioClassVM;
@property (nonatomic, strong) RadioViewModel *radioVM;
@property (nonatomic, strong) RadioViewModel * topViewModel;//排行榜

@end

@implementation HomeSubRadioController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"电台";
    [self dataRequest];
    [self signRadioRequest];
}

#pragma mark - Request

- (void)signRadioRequest {
    
    [RadioRequest getRadioSignWithSuccess:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            [self.signRadioArray removeAllObjects];
            NSArray *arr = [response objectForKey:@"data"];
            for (int i=0; i<arr.count; i++) {
                NSDictionary *dataDic = arr[i];
                HomeRadioSignModel *model = [[HomeRadioSignModel alloc] init];
                [model bindWithDic:dataDic];
                [self.signRadioArray addObject:model];
            }
            [self.radioSignTopView setDataArray:self.signRadioArray];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)dataRequest {
    
    NSInteger currentIndex = 0;
    if (_radioClassVM) {
        currentIndex = _radioClassVM.currentClassIndex;
    }
    
    [RadioRequest getRadioClassWithSuccess:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            
            [self.radioClassVM bindWithDic:response];
            if (currentIndex < self.radioClassVM.dataArr.count) {
                self.radioClassVM.currentClassIndex = currentIndex;
            }
            [self.tableView reloadData];
            
            if (self.radioClassVM.dataArr.count > 0) {
                if (self.radioClassVM.dataArr.count > self.radioClassVM.currentClassIndex) {
                    RadioClassModel *m = [self.radioClassVM.dataArr objectAtIndex:self.radioClassVM.currentClassIndex];
                    _radioClassModel = m;
                    [self detailListRequest:m isRefresh:YES];
                }
                else {
                    RadioClassModel *m = [self.radioClassVM.dataArr firstObject];
                    _radioClassModel = m;
                    [self detailListRequest:m isRefresh:YES];
                }
            }
        }
        else {
            [self.tableView.mj_header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        [self.tableView.mj_header endRefreshing];
    }];
    
    [self requesTrankingList];
}

- (void)detailListRequest:(RadioClassModel *)m isRefresh:(BOOL)isRefresh {
    
    if (isRefresh) {
        self.radioVM.page = 1;
        [self.tableView.mj_footer resetNoMoreData];
    }
    else {
        self.radioVM.page = self.radioVM.page + 1;
    }
    [RadioRequest getRadioDetailWithPage:self.radioVM.page pageSize:self.radioVM.pagesize targetId:(int)m.classId success:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
//            NSArray *array = [response objectForKey:@"data"];
            
            [self.radioVM bindWithDic:response isRefresh:isRefresh];
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:nil];
            [self.tableView reloadData];
            
        }
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        }
        else {
            if (!_radioVM.isMoreData) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        }
        else {
            if (!_radioVM.isMoreData) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [self.tableView.mj_footer resetNoMoreData];
            }
        }
    }];
}
//排行榜
- (void)requesTrankingList {
    [RadioRequest getRadioDetailTopWithSuccess:^(NSDictionary *response) {
        
        if ([[response objectForKey:@"status"] intValue] == 200) {
            [self.topViewModel bindWithDic:response];
            NSLog(@"____%@",response);
            if (self.topViewModel.dataArr.count > 0) {
                [self.tableView reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - 刷新数据
- (void)loadNewData{
    [self.tableView.mj_header beginRefreshing];
    [self dataRequest];
}

- (void)loadHistoryData{
    [self.tableView.mj_footer beginRefreshing];
    [self detailListRequest:_radioClassModel isRefresh:NO];
}

#pragma mark - TableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.radioVM.dataArr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        RadioHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:[RadioHeaderCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 1) {
        BaseBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:[BaseBannerCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        [cell setDataArr:self.topViewModel.dataArr];
        return cell;
    }
    else if (indexPath.section == 2) {
        RadioTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:[RadioTypeCell cellReuseIdentifierInfo] forIndexPath:indexPath];
        [cell bind:self.radioClassVM];
        cell.delegate = self;
        
        __weak __typeof(self)weakSelf = self;
        cell.showMoreOrHiddenBlock = ^(RadioTypeCell *blockCell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf userClickShowMoreOrHiddenBun];
        };
        return cell;
    }
    RadioCateCell *cell = [tableView dequeueReusableCellWithIdentifier:[RadioCateCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    
    RadioModel *m = [_radioVM.dataArr objectAtIndex:indexPath.row];
    [cell bind:m];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 124.5f;
    }
    else if (indexPath.section == 1) {
        return 150.f;
    }
    else if (indexPath.section == 2) {
        
        return (self.radioClassVM.showDataArr.count/4+1)*50;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        RadioTopViewController *vc = [[RadioTopViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 3) {
        RadioModel *m = [self.radioVM.dataArr objectAtIndex:indexPath.row];
        
        [Navigation showAudioPlayerViewController:self radioModel:m];
    }
}

#pragma mark - RadioHeaderTypeDelegate

- (void)radioHeaderSelectAction:(RadioHeaderType)type {
    
    RadioClassModel *m = [[RadioClassModel alloc] init];
    switch (type) {
        case RadioHeaderTypeProvince:
        {
            m.className = @"交通台";
            m.classId = 429;
        }
            break;
        case RadioHeaderTypeNational:
        {
            m.className = @"方言台";
            m.classId = 434;
        }
            break;
        case RadioHeaderTypeLocation:
        {
            m.className = @"本地台";
            m.classId = 99;
        }
            break;
        case RadioHeaderTypeNetwork:
        {
            m.className = @"娱乐台";
            m.classId = 442;
        }
            break;
    }
    
    RadioCateViewController *vc = [[RadioCateViewController alloc] init];
    vc.targetId = (int)m.classId;
    vc.title = m.className;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RadioClassTypeDelegate

- (void)radioClassSelectAction:(RadioClassModel *)model {
    
    _radioClassModel = model;
    [self detailListRequest:model isRefresh:YES];
}

#pragma mark - HomeRadioSignTopViewDelegate

- (void)itemSelected:(HomeRadioSignModel *)radioSignModel {
    RadioModel *m = [[RadioModel alloc] init];
    m.channelId = radioSignModel.rtcId;
    m.channelName = radioSignModel.name;
    [Navigation showAudioPlayerViewController:self radioModel:m];
}

#pragma mark - Action

- (void)userClickShowMoreOrHiddenBun {
    if( self.radioClassVM.style == RadioClassCellStyleHidden ) {
        self.radioClassVM.style = RadioClassCellStyleShow;
        [self.radioClassVM showAllDataArr];
    }
    else {
        self.radioClassVM.style = RadioClassCellStyleHidden;
        [self.radioClassVM showSectionDataArr];
    }
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - Get

- (RadioViewModel *)topViewModel {
    if (!_topViewModel) {
        _topViewModel = [[RadioViewModel alloc] init];
    }
    return _topViewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#ifdef __IPHONE_11_0
        if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        
        [_tableView registerNib:[UINib nibWithNibName:@"BaseBannerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[BaseBannerCell cellReuseIdentifierInfo]];
        [_tableView registerNib:[UINib nibWithNibName:@"RadioHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[RadioHeaderCell cellReuseIdentifierInfo]];
        [_tableView registerClass:[RadioTypeCell class] forCellReuseIdentifier:[RadioTypeCell cellReuseIdentifierInfo]];
        [_tableView registerNib:[UINib nibWithNibName:@"RadioCateCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[RadioCateCell cellReuseIdentifierInfo]];
        
        WeakObj(self);
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [selfWeak loadNewData];
        }];
        
        header.lastUpdatedTimeLabel.hidden = YES;
        _tableView.mj_header =  header;
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadHistoryData];
        }];
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (NSMutableArray *)signRadioArray {
    if (!_signRadioArray) {
        _signRadioArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _signRadioArray;
}

- (HomeRadioSignTopView *)radioSignTopView {
    if (!_radioSignTopView) {
        _radioSignTopView = [[HomeRadioSignTopView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 105)];
        _radioSignTopView.deleagte = self;
        self.tableView.tableHeaderView = _radioSignTopView;
    }
    return _radioSignTopView;
}

- (RadioClassViewModel *)radioClassVM {
    if(!_radioClassVM) {
        _radioClassVM = [[RadioClassViewModel alloc] init];
    }
    return _radioClassVM;
}

- (RadioViewModel *)radioVM {
    if (!_radioVM) {
        _radioVM = [[RadioViewModel alloc] init];
        _radioVM.page = 1;
        _radioVM.pagesize = 5;
    }
    return _radioVM;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
