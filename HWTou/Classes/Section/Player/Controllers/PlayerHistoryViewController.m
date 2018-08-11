//
//  PlayerHistoryViewController.m
//  HWTou
//
//  Created by Reyna on 2017/11/30.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PlayerHistoryViewController.h"
#import "RadioRequest.h"
#import "RadioCateCell.h"
#import "PlayerHistoryViewModel.h"
#import "PublicHeader.h"
#import "PlayerHistoryTableViewCell.h"
#import "PlayerHistoryHeaderView.h"

@interface PlayerHistoryViewController () <UITableViewDelegate, UITableViewDataSource,PlayerHistoryHeaderViewDelegate>

@property (nonatomic,strong) PlayerHistoryHeaderView * historyHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton * bottomBtn;
@property (nonatomic, strong) PlayerHistoryViewModel *historyVM;
@property (nonatomic, strong) UIButton *btnEdit;
@property (nonatomic ,strong) NSMutableArray *deleteArray;//删除的数据
@end

@implementation PlayerHistoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"播放历史";
    [self addNaviBar];
    [self addMainView];
    [self dataRequest:YES];
}

- (void)addNaviBar {
    
    UIBarButtonItem *itemEdit = [UIBarButtonItem itemWithTitle:@"编辑" withColor:UIColorFromHex(0x8e8f91) target:self action:@selector(editAction)];
    self.btnEdit = itemEdit.customView;
    [self.btnEdit setTitle:@"完成" forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = itemEdit;
}

- (void)addMainView{
    [self.view addSubview:self.historyHeaderView];
    [self.view addSubview:self.tableView];
    
    [self.historyHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kMainScreenWidth, 44));
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(-50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(kMainScreenWidth);
        make.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.bottomBtn];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(50);
        make.size.equalTo(CGSizeMake(kMainScreenWidth, 50));
    }];
}

- (void)dataRequest:(BOOL)isRefresh {
    
    if (isRefresh) {
        self.historyVM.page = 1;
    }else{
        self.historyVM.page ++;
        
        [self.tableView.mj_footer beginRefreshing];
    }
    
    [RadioRequest lookHistoryWithPage:self.historyVM.page pageSize:self.historyVM.pagesize success:^(NSDictionary *response) {
        if ([[response objectForKey:@"status"] intValue] == 200) {
            [self.historyVM bindWithDic:response isRefresh:isRefresh];
            [self.tableView reloadData];
            if (self.historyVM.isMoreData) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
//删除
- (void)delHistoryWithRtcIDs{
    NSString * rtcIds = @"";
    for (PlayerHistoryModel * historyModel in self.deleteArray) {
        if ([rtcIds isEqualToString:@""]) {
            rtcIds = [NSString stringWithFormat:@"%d",historyModel.rtcId];
        }else{
            rtcIds = [NSString stringWithFormat:@"%@,%d",rtcIds,historyModel.rtcId];
        }
    }
    int isAll = self.historyHeaderView.isCheck?1:0;
        
    [RadioRequest delHistoryWithRtcIDs:rtcIds isAll:isAll success:^(NSDictionary *response) {
        if ([response[@"status"] intValue] == 200) {
            [self deleteData];
            if (self.historyHeaderView.isCheck) {
                [self editAction];
            }
        }else{
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - PlayerHistoryHeaderViewDelegate

- (void)allSelected{
    for (int i = 0; i< self.historyVM.dataArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //全选实现方法
        [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    //点击全选的时候需要清除deleteArray里面的数据，防止deleteArray里面的数据和列表数据不一致
    if (self.deleteArray.count >0) {
        [self.deleteArray removeAllObjects];
    }
    [self.deleteArray addObjectsFromArray:self.historyVM.dataArr];
    
}

- (void)cancelSelected{
    //取消选中
    for (int i = 0; i< self.historyVM.dataArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    [self.deleteArray removeAllObjects];
}

#pragma mark - TableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _historyVM.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlayerHistoryTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    
    PlayerHistoryModel *m = [_historyVM.dataArr objectAtIndex:indexPath.row];
    [cell.listView setHistoryModel:m];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {//选中
        [self.deleteArray addObject:[self.historyVM.dataArr objectAtIndex:indexPath.row]];
        [self.historyHeaderView setIsCheck:self.deleteArray.count == self.historyVM.dataArr.count];
    }else{
        PlayerHistoryModel *m = [self.historyVM.dataArr objectAtIndex:indexPath.row];
        [Navigation showAudioPlayerViewController:self radioModel:m];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        NSLog(@"撤销");
        [self.deleteArray removeObject:[self.historyVM.dataArr objectAtIndex:indexPath.row]];
        [self.historyHeaderView setIsCheck:NO];
    }else{
        NSLog(@"取消跳转");
    }
}

#pragma mark - 多选
//删除数据方法
- (void)deleteData{
    if (self.deleteArray.count >0) {
        [self.historyVM.dataArr removeObjectsInArray:self.deleteArray];
        [self.tableView reloadData];
    }

}

#pragma mark - Action

- (void)buttonSelected:(UIButton *)button{
    if (self.deleteArray.count == 0) {
        [HUDProgressTool showSuccessWithText:@"请勾选删除内容"];
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定要删除已选历史吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self delHistoryWithRtcIDs];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancleAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (void)editAction {
    self.btnEdit.selected = !self.btnEdit.selected;
    
    NSTimeInterval animationDuration = 0.50f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if (self.btnEdit.selected) {//编辑
        
        [self.historyHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(44);
            make.bottom.equalTo(self.view).offset(-50);
        }];
        
        [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
    }else{
        [self.historyHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-50);
        }];
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        
        [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(50);
        }];
    }
    
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    
    if (self.btnEdit.selected) {//编辑
        _tableView.mj_footer = nil;
    }else{
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self dataRequest:NO];
        }];
    }
    [self.historyHeaderView setIsCheck:NO];
    [self.tableView setEditing:self.btnEdit.selected animated:YES];
}

#pragma mark - Get

- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
        _bottomBtn.backgroundColor = UIColorFromHex(0xAD0021);
        [_bottomBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    return _bottomBtn;
}

- (NSMutableArray *)deleteArray{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (PlayerHistoryHeaderView *)historyHeaderView{
    if (!_historyHeaderView) {
        _historyHeaderView = [[PlayerHistoryHeaderView alloc] init];
        _historyHeaderView.historyDelegate = self;
    }
    return _historyHeaderView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[PlayerHistoryTableViewCell class] forCellReuseIdentifier:[PlayerHistoryTableViewCell cellReuseIdentifierInfo]];
//        _tableView.estimatedRowHeight = 110;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        __weak typeof(self) weakSelf = self;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf dataRequest:NO];
        }];
    }
    return _tableView;
}

- (PlayerHistoryViewModel *)historyVM {
    if (!_historyVM) {
        _historyVM = [[PlayerHistoryViewModel alloc] init];
        _historyVM.page = 1;
        _historyVM.pagesize = 10;
    }
    return _historyVM;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
