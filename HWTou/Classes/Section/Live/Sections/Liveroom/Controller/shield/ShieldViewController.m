//
//  ShieldViewController.m
//  HWTou
//
//  Created by robinson on 2017/12/1.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ShieldViewController.h"
#import "PublicHeader.h"
#import "TopicTitleListCollectionViewCell.h"
#import "PersonHomeReq.h"
#import "ShieldTableViewCell.h"

#define identifity @"identifity"

@interface ShieldViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) PersonHomeParam * listParam;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation ShieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setTitle:@"屏蔽的人"];
    [self request:YES];

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
    //粉丝列表
    [PersonHomeRequest focusAndFansAndShiledList:self.listParam Success:^(CityInfoResponse *response) {
        if (response.status == 200) {
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            
            NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:response.data.count];
            for (NSDictionary * dataDict in response.data) {
                FocusUserListDM * listDM = [FocusUserListDM new];
                [listDM setValuesForKeysWithDictionary:dataDict];
                
                [resultArray addObject:listDM];
            }
            [self.dataArray addObjectsFromArray:resultArray];
            [self.tableView reloadData];
            if (resultArray.count<self.listParam.pagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [HUDProgressTool showIndicatorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
    
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShieldTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[ShieldTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    [cell setFocusUserListDM:self.dataArray[indexPath.row]];
    return cell;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"取消屏蔽";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    //删除数据，和删除动画
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消屏蔽" message:@"确定要取消屏蔽吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        FocusUserListDM * model = self.dataArray[indexPath.row];
        ShieldSomeOneParam * delTopicParam = [ShieldSomeOneParam new];
        delTopicParam.shieldId = model.uid;
        
        [PersonHomeRequest shieldSomeOne:delTopicParam Success:^(BaseResponse *response) {
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
    
    FocusUserListDM * topicListModel = self.dataArray[indexPath.row];
    [Navigation showPersonalHomePageViewController:self attendType:dynamicButtonType uid:topicListModel.uid];
}

#pragma mark - getter

- (PersonHomeParam *)listParam{
    if (!_listParam) {
        _listParam = [PersonHomeParam new];
        _listParam.flag = 3;
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
        [self.tableView registerNib:[UINib nibWithNibName:@"ShieldTableViewCell" bundle:nil]
             forCellReuseIdentifier:[ShieldTableViewCell cellReuseIdentifierInfo]];
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
