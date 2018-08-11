//
//  MeChatViewController.m
//  HWTou
//
//  Created by robinson on 2018/1/2.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MeChatViewController.h"
#import "RotRequest.h"
#import "PublicHeader.h"
#import "GuessULikeModel.h"
#import "HotMoreTableViewCell.h"
#import "GetMyChatsTModel.h"
#import "UIView+Toast.h"

@interface MeChatViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation MeChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的聊吧"];
    
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
    if (_isSuperManager) {
        [RotRequest getAdminChats:^(ArrayResponse *response) {
            if (response.status == 200) {
                
                NSArray * rtcDetailListArr = response.data;
                
                NSMutableArray * resultArr = [NSMutableArray array];
                for (NSDictionary * resultDict in rtcDetailListArr) {
                    GetMyChatsTModel * likeModel = [GetMyChatsTModel new];
                    [likeModel setValuesForKeysWithDictionary:resultDict];
                    
                    [resultArr addObject:likeModel];
                }
                [self.dataArray addObjectsFromArray:resultArr];
                
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [RotRequest getMyChatsT:^(ArrayResponse *response) {
            if (response.status == 200) {
                
                NSArray * rtcDetailListArr = response.data;
                
                NSMutableArray * resultArr = [NSMutableArray array];
                for (NSDictionary * resultDict in rtcDetailListArr) {
                    GetMyChatsTModel * likeModel = [GetMyChatsTModel new];
                    [likeModel setValuesForKeysWithDictionary:resultDict];
                    
                    [resultArr addObject:likeModel];
                }
                [self.dataArray addObjectsFromArray:resultArr];
                
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            
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
    HotMoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[HotMoreTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    [cell setMyChatsTModel:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetMyChatsTModel * myChatsTModel = self.dataArray[indexPath.row];
    GuessULikeModel * ulikeModel = [GuessULikeModel new];
    ulikeModel.roomId = myChatsTModel.roomId;
    ulikeModel.rtcId = myChatsTModel.rtcId;
    if (_isSuperManager) {//超级管理员
        ulikeModel.isSuperManager = YES;
        [Navigation lookLiveRoom:self model:ulikeModel];
    }else{//主播
        if (myChatsTModel.isOnline == 1) {
            [HUDProgressTool showOnlyText:@"已有聊吧在直播"];
            return;
        }
        
        [Navigation joinPushLiveRoom:self model:ulikeModel];
    }
    
}

#pragma mark - getter

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
    }
    return _tableView;
}


@end
