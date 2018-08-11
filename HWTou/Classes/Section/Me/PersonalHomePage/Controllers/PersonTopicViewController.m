//
//  PersonTopicViewController.m
//  HWTou
//
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonTopicViewController.h"
#import "PublicHeader.h"
#import "PersonDynamicStateCell.h"
#import "RadioRequest.h"
#import "CollectSessionReq.h"
#import "TopicWorkDetailModel.h"
#import "TopicTitleListCollectionViewCell.h"

static NSString *MyCellID = @"thisIsMyCellId2";

@interface PersonTopicViewController ()<PersonDynamicStateCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) HotTopicListParam * listParam;
@end

@implementation PersonTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.personHomePageView.frame.size.height, 0, 0, 0);
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, self.personHomePageView.frame.size.height)];
    self.tableView.tableHeaderView = tableHeaderView;
    
    [self requestTopicList:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - uitableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.personHomePageView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicTitleListTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:MyCellID forIndexPath:indexPath];
//    cell.dynamicDelegate = self;
    [cell.topicTitleListView setTopicListModel:self.dataArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyTopicListModel * detailModel = self.dataArray[indexPath.row];
    [_dynamicDeleagte didTotpicSelectRowAtIndexPath:detailModel];
}

#pragma mark - PersonDynamicStateCellDelegate

- (void)likeButtonSelected:(UserDetailModel *)detailModel{
    //按markState判断，这个里面现在只有，1：发表的话题，2：评论，3：回复
    //如果是markState=1调话题点赞
    //如果markState=2||markState=3调评论点赞
    if (detailModel.markState == 1) {
        [RadioRequest praiseTopicWithTopicId:(int)detailModel.rtcId success:^(NSDictionary *response) {
            if ([response[@"status"] intValue] == 200) {
                [self reloadLikeView:detailModel];
            }else{
                [HUDProgressTool showErrorWithText:response[@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }else if (detailModel.markState == 2 || detailModel.markState == 3){
        [RadioRequest praiseCommentWithCommentId:(int)detailModel.commentId success:^(NSDictionary *response) {
            if ([response[@"status"] intValue] == 200) {
                [self reloadLikeView:detailModel];
            }else{
                [HUDProgressTool showErrorWithText:response[@"msg"]];
            }
        } failure:^(NSError *error) {
            [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        }];
    }
    
}

#pragma mark - 刷新点赞
- (void)reloadLikeView:(UserDetailModel *)detailModel{
    if (detailModel.isPaise == 0) {
        detailModel.isPaise = 1;
        detailModel.praise ++;
    }else if (detailModel.isPaise == 1){
        detailModel.isPaise = 0;
        detailModel.praise --;
    }
    [self.tableView reloadData];
}

#pragma mark - getter,setter

- (HotTopicListParam *)listParam{
    if (!_listParam) {
        _listParam = [HotTopicListParam new];
    }
    return _listParam;
}

- (void)requestTopicList:(BOOL)isRefresh{
    
    if (isRefresh) {//下拉刷新
        self.listParam.page = 1;
    }else{
        self.listParam.page+=1;
    }
    
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
        }
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];

}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStyleGrouped delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[TopicTitleListTableViewCell class] forCellReuseIdentifier:MyCellID];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestTopicList:NO];
        }];
    }
    return _tableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.personHomePageView.frame;
    CGFloat placeHolderHeight = frame.size.height - 40;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0 && offsetY <= placeHolderHeight) {
        frame.origin.y = -offsetY;
    } else if (offsetY > placeHolderHeight) {
        frame.origin.y = - placeHolderHeight;
    } else if (offsetY <0) {
        frame.origin.y =  - offsetY;
    }
    self.personHomePageView.frame = frame;
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
