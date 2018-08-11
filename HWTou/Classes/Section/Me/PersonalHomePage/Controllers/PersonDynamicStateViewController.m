//
//  PersonDynamicStateViewController.m
//  HWTou
//
//  Created by robinson on 2017/11/16.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PersonDynamicStateViewController.h"
#import "PublicHeader.h"
#import "PersonDynamicStateCell.h"
#import "RadioRequest.h"
#import "CollectSessionReq.h"

static NSString *MyCellID = @"thisIsMyCellId";

@interface PersonDynamicStateViewController ()<PersonDynamicStateCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) MarkDetailParam * listParam;
@end

@implementation PersonDynamicStateViewController

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
    
    [self requestUserDynamic:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - uitableview

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
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
    PersonDynamicStateCell * cell = [self.tableView dequeueReusableCellWithIdentifier:MyCellID forIndexPath:indexPath];
    cell.dynamicDelegate = self;
    [cell setDetailModel:self.dataArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserDetailModel * detailModel = self.dataArray[indexPath.row];
    [_dynamicDeleagte didSelectRowAtIndexPath:detailModel];
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
- (void)setDataArray:(NSArray *)dataArray{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:dataArray];
    [self.tableView reloadData];
}

- (MarkDetailParam *)listParam{
    if (!_listParam) {
        _listParam = [MarkDetailParam new];
    }
    return _listParam;
}

- (void)requestUserDynamic:(BOOL)isRefresh{
    if (isRefresh) {//下拉刷新
        self.listParam.page = 1;
    }else{
        self.listParam.page+=1;
    }
    
//    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    if (_editDataButtonType == editDataButtonType) {
        self.listParam.targetId = 0;
    }else{
        self.listParam.targetId = _uid;
    }
    //动态
    [CollectSessionReq userDetail:self.listParam Success:^(MyTopicListResponse *response) {
//        [HUDProgressTool dismiss];
        if (response.status == 200) {

            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            NSMutableArray * resultArray = [NSMutableArray array];
            for (NSDictionary * dataResult in response.data) {
                UserDetailModel * detailModel = [UserDetailModel new];
                [detailModel setValuesForKeysWithDictionary:dataResult];
                
                [resultArray addObject:detailModel];
            }
            [self.dataArray addObjectsFromArray:resultArray];
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

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStyleGrouped delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[PersonDynamicStateCell class] forCellReuseIdentifier:MyCellID];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestUserDynamic:NO];
        }];
        //高度自适应
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
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

@end
