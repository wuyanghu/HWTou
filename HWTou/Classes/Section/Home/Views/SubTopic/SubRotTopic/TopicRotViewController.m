//
//  TopicRotViewController.m
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TopicRotViewController.h"
#import "PublicHeader.h"
#import "TopicTitleListCollectionViewCell.h"
#import "CollectSessionReq.h"

#define identifity @"identifity"

@interface TopicRotViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) HotTopicListParam * listParam;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation TopicRotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    if (_topicType == TopicRotType) {
        [self setTitle:@"热门主播"];
        [self request:YES];
    }else if (_topicType == TopicMeType){
        [self setTitle:@"我的话题"];
        [self request:YES];
    }

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)request:(BOOL)isRefresh{
    if (isRefresh) {//下拉刷新
        self.listParam.page = 1;
    }else{
        self.listParam.page+=1;
    }
    if (_topicType == TopicRotType) {
        [CollectSessionReq getHotTopicList:self.listParam Success:^(MyTopicListResponse *response) {
            if (response.status == 200) {
                if (isRefresh) {
                    [self.dataArray removeAllObjects];
                }
                NSMutableArray * array = [NSMutableArray array];
                for (NSDictionary * dict in response.data) {
                    MyTopicListModel * listModel = [MyTopicListModel new];
                    [listModel setValuesForKeysWithDictionary:dict];
                    [array addObject:listModel];
                }
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                
                if (response.data.count<self.listParam.pagesize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
                
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
                [self.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else if (_topicType == TopicMeType){
        [CollectSessionReq getMyTopicList:self.listParam Success:^(MyTopicListResponse *response) {
            if (response.status == 200) {
                if (isRefresh) {
                    [self.dataArray removeAllObjects];
                }
                NSMutableArray * array = [NSMutableArray array];
                for (NSDictionary * dict in response.data) {
                    MyTopicListModel * listModel = [MyTopicListModel new];
                    [listModel setValuesForKeysWithDictionary:dict];
                    [array addObject:listModel];
                }
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                
                if (response.data.count<self.listParam.pagesize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
                
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
                [self.tableView.mj_footer endRefreshing];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
            [self.tableView.mj_footer endRefreshing];
        }];
    }
    
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicTitleListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifity forIndexPath:indexPath];
    [cell.topicTitleListView setTopicListModel:self.dataArray[indexPath.row]];
    return cell;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_topicType == TopicMeType) {
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
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    //删除数据，和删除动画
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除主播" message:@"确定要删除主播吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        MyTopicListModel * model = self.dataArray[indexPath.row];
        DelTopicParam * delTopicParam = [DelTopicParam new];
        delTopicParam.topicId = model.topicId;
        
        [CollectSessionReq delTopic:delTopicParam Success:^(BaseResponse *response) {
            if (response.status == 200) {
                [HUDProgressTool showSuccessWithText:ReqSuccessful];
                
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            }else{
                [HUDProgressTool showErrorWithText:response.msg];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_topicType == TopicRotType) {
        NSLog(@"点击进入详情");
    }else if (_topicType == TopicMeType){
        NSLog(@"点击进入详情");
    }
    MyTopicListModel * topicListModel = self.dataArray[indexPath.row];
    [Navigation showAudioPlayerViewController:self radioModel:topicListModel];
}

#pragma mark - getter

- (HotTopicListParam *)listParam{
    if (!_listParam) {
        _listParam = [HotTopicListParam new];
    }
    return _listParam;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStylePlain delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView registerClass:[TopicTitleListTableViewCell class] forCellReuseIdentifier:identifity];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self request:NO];
        }];
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
