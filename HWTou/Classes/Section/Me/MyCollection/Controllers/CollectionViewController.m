//
//  CollectionViewController.m
//  HWTou
//
//  Created by robinson on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "CollectionViewController.h"
#import "RadioRequest.h"
#import "PublicHeader.h"
#import "SearchTableViewCell.h"
#import "CollectionViewModel.h"

@interface CollectionViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton * topicBtn;
    UIButton * radioBtn;
    UIButton * chatBtn;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) CollectionViewModel * viewModel;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的收藏"];
    [self addMainView];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestCollect:YES];
}

- (void)addMainView{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    [self.view addSubview:bgView];
    
    NSInteger btnNum = 3;
    CGFloat space = (kMainScreenWidth-20-80*btnNum)/(btnNum-1);
    
    CGRect frame = CGRectMake(10, 15, 80, 30);
    chatBtn = [self createButton:frame tag:103 title:@"聊吧"];
    [self.view addSubview:chatBtn];
    
    frame = CGRectMake(frame.origin.x+frame.size.width+space, frame.origin.y, frame.size.width, frame.size.height);
    topicBtn = [self createButton:frame tag:101 title:@"主播"];
    [self.view addSubview:topicBtn];
    
    frame = CGRectMake(frame.origin.x+frame.size.width+space, frame.origin.y, frame.size.width, frame.size.height);
    radioBtn = [self createButton:frame tag:102 title:@"电台"];
    [self.view addSubview:radioBtn];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.equalTo(kMainScreenWidth);
        make.top.equalTo(topicBtn.mas_bottom).offset(15);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button事件
- (void)buttonSelected:(UIButton *)button{
    if (button.tag == 101) {//话题
        self.viewModel.flag = 2;
    }else if (button.tag == 102){//广播
        self.viewModel.flag = 1;
    }else if (button.tag == 103){//聊吧
        self.viewModel.flag = 3;
    }
    [self requestCollect:YES];
}

#pragma mark - 网络请求
- (void)requestCollect:(BOOL)isRefresh{
    
    if (self.viewModel.flag == 2) {
        topicBtn.selected = YES;
        radioBtn.selected = NO;
        chatBtn.selected = NO;
    }else if (self.viewModel.flag == 1){
        topicBtn.selected = NO;
        radioBtn.selected = YES;
        chatBtn.selected = NO;
    }else if(self.viewModel.flag == 3){
        topicBtn.selected = NO;
        radioBtn.selected = NO;
        chatBtn.selected = YES;
    }
    
    if (isRefresh) {
        self.viewModel.page = 1;
    }else{
        self.viewModel.page ++;
    }
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    [RadioRequest getMycollect:self.viewModel.page pageSize:self.viewModel.pagesize flag:self.viewModel.flag success:^(NSDictionary * response) {
        [HUDProgressTool dismiss];
        if ([response[@"status"] integerValue] == 200) {
            [self.viewModel bindWithDic:response isRefresh:isRefresh];
            [self.tableView reloadData];
            if (self.viewModel.isMoreData) {
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            
        }
        
    } failure:^(NSError * error) {
        [HUDProgressTool dismiss];
    }];
}

#pragma mark - TableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    
    GuessULikeModel *m = [self.viewModel.dataArray objectAtIndex:indexPath.row];
    [cell.listView setLikeModel:m isShowLine:NO];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Navigation showAudioPlayerViewController:self radioModel:[self.viewModel.dataArray objectAtIndex:indexPath.row]];
}

#pragma mark - getter

- (UIButton *)createButton:(CGRect)frame tag:(NSInteger)tag title:(NSString *)title{
    UIButton * button = [BasisUITool getBtnWithTarget:self action:@selector(buttonSelected:)];
    button.tag = tag;
    button.frame = frame;
    [button.layer setCornerRadius:15.0];
    [button.layer setMasksToBounds:YES];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromHex(0x2B2B2B) forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromHex(0xAD0021) forState:UIControlStateSelected];
    [button setBackgroundColor:UIColorFromHex(0xeeeeee)];
    
    return button;
}

- (CollectionViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[CollectionViewModel alloc] init];
        _viewModel.page = 1;
        _viewModel.pagesize = 10;
        _viewModel.flag = 3;//默认聊吧
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:[SearchTableViewCell cellReuseIdentifierInfo]];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self requestCollect:NO];
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
