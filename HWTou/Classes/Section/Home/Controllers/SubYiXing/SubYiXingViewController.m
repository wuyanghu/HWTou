//
//  SubYiXingViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "SubYiXingViewController.h"
#import "SubYiXingTableViewCell.h"
#import "ShopMallRequest.h"
#import "PublicHeader.h"
#import "GetFayeArtModel.h"
#import "ComWebViewController.h"

@interface SubYiXingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    GetFayeArtParam * getFayeArtParam;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray<GetFayeArtModel *> * dataArray;
@end

@implementation SubYiXingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"艺讯"];
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dataInit{
    self.view.backgroundColor = UIColorFromRGB(0xF3F4F6);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SubYiXingTableViewCell" bundle:nil]
         forCellReuseIdentifier:[SubYiXingTableViewCell cellReuseIdentifierInfo]];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestGetFayeArt:NO];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestGetFayeArt:YES];
    }];
    
    [self requestGetFayeArt:YES];
}

#pragma mark - network
- (void)requestGetFayeArt:(BOOL)isRefresh{
    
    if (!getFayeArtParam) {
        getFayeArtParam = [GetFayeArtParam new];
        getFayeArtParam.pagesize = 20;
        getFayeArtParam.status = 1;
    }
    
    if (isRefresh) {
        getFayeArtParam.page = 1;
    }else{
        getFayeArtParam.page++;
    }
    
    [ShopMallRequest getFayeArt:getFayeArtParam Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary * detailDict in response.data[@"fayeArts"]) {
                GetFayeArtModel * detailModel = [GetFayeArtModel new];
                [detailModel setValuesForKeysWithDictionary:detailDict];
                
                [self.dataArray addObject:detailModel];
            }
            
            [self.tableView reloadData];
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
            }else{
                if (response.data.count<getFayeArtParam.pagesize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubYiXingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[SubYiXingTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    [cell setGetFayeArtModel:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor whiteColor];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* footView = [[UIView alloc]initWithFrame:CGRectZero];
    footView.backgroundColor = UIColorFromRGB(0xF3F4F6);
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ComWebViewController *webVC = [[ComWebViewController alloc] init];
    GetFayeArtModel * model =  self.dataArray[indexPath.row];
    webVC.webUrl = model.linkUrl;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - getter
- (NSMutableArray<GetFayeArtModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
