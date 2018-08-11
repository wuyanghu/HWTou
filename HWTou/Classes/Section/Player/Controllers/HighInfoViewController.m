//
//  HighInfoViewController.m
//  HWTou
//
//  Created by robinson on 2018/1/5.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "HighInfoViewController.h"
#import "PublicHeader.h"
#import "HistoryTopTableViewCell.h"
#import "RadioRequest.h"
#import "PlayHighInfoViewModel.h"
#import "HighInfoPlayInstance.h"

@interface HighInfoViewController ()<UITableViewDataSource,UITableViewDelegate,HistoryTopTableViewCellDelegate>
@property (nonatomic,strong) TopComsParam * topComsParam;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) PlayHighInfoViewModel * highInfoVM;
@end

@implementation HighInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"正在直播"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getTopComsMj_headerRequest{
    self.highInfoVM.topComsParam.chatId = self.chatId;
    TopComsParam * topComsParam = self.highInfoVM.topComsParam;
    self.topComsParam.chatId = topComsParam.chatId;
    self.topComsParam.page = 1;
    
    [RadioRequest getTopComs:self.topComsParam success:^(NSDictionary * response) {
        [self.highInfoVM.dataArray removeAllObjects];
        [self.highInfoVM bindWithDic:response isRefresh:YES];
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError * error) {
        
    }];
}


- (void)getTopComsRequest:(BOOL)isRefresh{
    self.highInfoVM.topComsParam.chatId = self.chatId;
    TopComsParam * topComsParam = self.highInfoVM.topComsParam;
    self.topComsParam.chatId = topComsParam.chatId;
    
    if (isRefresh) {
        self.topComsParam.page = 1;
    }else{
        self.topComsParam.page ++;
    }
    
    [RadioRequest getTopComs:self.topComsParam success:^(NSDictionary * response) {
        [self.highInfoVM bindWithDic:response isRefresh:isRefresh];
        [self.tableView reloadData];
        
        if (isRefresh) {
            [self.tableView.mj_header endRefreshing];
        }else{
            if (self.highInfoVM.isMoreData) {
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    } failure:^(NSError * error) {

    }];
}

#pragma mark - HistoryTopTableViewCellDelegate
//设置当前播放
- (void)voiceReplyViewClick:(HistoryTopModel *)topModel{
    [self.playInstance setCurrentPlayModel:topModel];
}

- (void)praise:(NSInteger)commentId{
    WeakObj(self);
    [RadioRequest praiseCommentWithCommentId:(int)commentId success:^(NSDictionary * response) {
        [selfWeak getTopComsRequest:YES];
    } failure:^(NSError * error) {
        
    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.highInfoVM.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[HistoryTopTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    cell.topDelegate = self;
    cell.isClickPlay = YES;
    if (indexPath.row<self.highInfoVM.dataArray.count) {
        [cell setTopModel:self.highInfoVM.dataArray[indexPath.row]];
    }else{
        NSLog(@"越界了");
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isWorkChat) {
        return YES;
    }
    return NO;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"移除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    //删除数据，和删除动画
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"移除聊吧" message:@"确定要移除聊吧吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        HistoryTopModel * model = self.highInfoVM.dataArray[indexPath.row];
        DelTopComParam * delTopicParam = [DelTopComParam new];
        delTopicParam.comId = model.comId;
        
        [RadioRequest delTopCom:delTopicParam success:^(NSDictionary * response) {
            if ([response[@"status"] integerValue] == 200) {
                [HUDProgressTool showSuccessWithText:ReqSuccessful];
                
                [self.highInfoVM.dataArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            }else{
                [HUDProgressTool showErrorWithText:response[@"msg"]];
            }
        } failure:^(NSError * error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - getter

- (TopComsParam *)topComsParam{
    if (!_topComsParam) {
        _topComsParam = [TopComsParam new];
    }
    return _topComsParam;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStylePlain delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView registerNib:[UINib nibWithNibName:@"HistoryTopTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[HistoryTopTableViewCell cellReuseIdentifierInfo]];
        
        WeakObj(self);
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [selfWeak getTopComsRequest:NO];
        }];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [selfWeak.playInstance.highInfoVM.dataArray removeAllObjects];//手动下拉刷新，移除所有
            [selfWeak getTopComsMj_headerRequest];
        }];
    }
    return _tableView;
}

- (PlayHighInfoViewModel *)highInfoVM{
    if (!_highInfoVM) {
        _highInfoVM = self.playInstance.highInfoVM;
    }
    return _highInfoVM;
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
