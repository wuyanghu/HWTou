//
//  HomeSubCategoryDetailViewController.m
//  HWTou
//
//  Created by robinson on 2018/1/4.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "HomeSubCategoryDetailViewController.h"
#import "PublicHeader.h"
#import "HotMoreTableViewCell.h"
#import "RotRequest.h"

@interface HomeSubCategoryDetailViewController ()
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) ChatByClassParam * changeListParam;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation HomeSubCategoryDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"聊吧"];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self requestChangeListParam:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - network
- (void)requestChangeListParam:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.changeListParam.page = 1;
    }else{
        self.changeListParam.page ++;
    }
    self.changeListParam.classId = _classId;
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    [RotRequest getChatByClass:self.changeListParam Success:^(ArrayResponse *response) {
        [HUDProgressTool dismiss];
        if (response.status == 200) {
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            NSArray * rtcDetailListArr = response.data;
            
            NSMutableArray * resultArr = [NSMutableArray array];
            for (NSDictionary * resultDict in rtcDetailListArr) {
                GuessULikeModel * likeModel = [GuessULikeModel new];
                [likeModel setValuesForKeysWithDictionary:resultDict];
                
                [resultArr addObject:likeModel];
            }
            [self.dataArray addObjectsFromArray:resultArr];
            
            if (rtcDetailListArr.count<self.changeListParam.pagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        [HUDProgressTool dismiss];
    }];
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
    HotMoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[HotMoreTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    [cell setUlistModel:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _detailBlock(self.dataArray[indexPath.row]);
}

#pragma mark - getter
- (ChatByClassParam *)changeListParam{
    if (!_changeListParam) {
        _changeListParam = [ChatByClassParam new];
        _changeListParam.page = 1;
        _changeListParam.pagesize = 10;
    }
    return _changeListParam;
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
        [_tableView registerClass:[HotMoreTableViewCell class] forCellReuseIdentifier:[HotMoreTableViewCell cellReuseIdentifierInfo]];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestChangeListParam:NO];
        }];
    }
    return _tableView;
}
@end
