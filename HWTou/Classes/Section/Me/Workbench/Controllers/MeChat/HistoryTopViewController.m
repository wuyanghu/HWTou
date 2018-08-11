//
//  HistoryTopViewController.m
//  HWTou
//
//  Created by robinson on 2018/1/2.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "HistoryTopViewController.h"
#import "RotRequest.h"
#import "PublicHeader.h"
#import "HistoryTopModel.h"
#import "HistoryTopTableViewCell.h"
#import "GuessULikeModel.h"
#import "PGDatePickManager.h"
#import "RadioRequest.h"

@interface HistoryTopViewController ()<UITableViewDataSource,UITableViewDelegate,PGDatePickerDelegate,HistoryTopTableViewCellDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) TopComHistoriesParam * topComHistoriesParam;
@property (nonatomic,strong) NSMutableArray<HistoryTopModel *> * dataArray;
@property (nonatomic,strong) NSMutableArray<GuessULikeModel *> * chatDataArray;
@property (nonatomic,strong) NSMutableDictionary * attendViewDict;
@end

@implementation HistoryTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"历史置顶"];
    UIButton * rightBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(rightBtnSelected)];
    [rightBtn setImage:[UIImage imageNamed:@"lszd_btn_time"] forState:UIControlStateNormal];
    
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:barButtonItem];

    [self requestChangeListParam];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addMainView{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    [self.view addSubview:bgView];
    
    NSInteger btnNum = 3;
    CGFloat space = 10;
    CGFloat width = (kMainScreenWidth-40)/btnNum;
    
    if (self.chatDataArray.count == 0) {
        return;
    }
    
    
    UIButton * attendView = nil;//记住的是最后一个
    
    if (self.attendViewDict.count != self.chatDataArray.count) {
        for (UIButton * tempAttendView in self.attendViewDict.allValues) {
            [tempAttendView removeFromSuperview];
        }
        [self.attendViewDict removeAllObjects];
    }
    
    for (int i = 0; i<self.chatDataArray.count; i++) {
        GuessULikeModel * ulikeModel = self.chatDataArray[i];
        NSString * keyUid = [NSString stringWithFormat:@"%ld",ulikeModel.rtcId];
        UIButton * tempAttendView = self.attendViewDict[keyUid];
        if (tempAttendView == nil) {
            tempAttendView = [self createButton:CGRectZero tag:ulikeModel.rtcId title:ulikeModel.name];
            [self.view addSubview:tempAttendView];
            
            if (attendView == nil) {
                tempAttendView.selected = YES;
                self.topComHistoriesParam.chatId = ulikeModel.rtcId;
                
                [tempAttendView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view).offset(10);
                    make.top.equalTo(self.view).offset(10);
                    make.size.equalTo(CGSizeMake(width, 30));
                }];
            }else{
                [tempAttendView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(attendView.mas_right).offset(space);
                    make.top.equalTo(attendView);
                    make.size.equalTo(attendView);
                }];
            }
            
            attendView = tempAttendView;
        }
        
        [self.attendViewDict setObject:tempAttendView forKey:keyUid];
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.equalTo(kMainScreenWidth);
        make.top.equalTo(attendView.mas_bottom).offset(15);
    }];
}

#pragma mark - network

- (void)requestChangeListParam{
    
    [RotRequest getMyChats:^(ArrayResponse *response) {
        
        NSArray * rtcDetailListArr = response.data;
        
        NSMutableArray * resultArr = [NSMutableArray array];
        for (NSDictionary * resultDict in rtcDetailListArr) {
            GuessULikeModel * likeModel = [GuessULikeModel new];
            [likeModel setValuesForKeysWithDictionary:resultDict];
            
            [resultArr addObject:likeModel];
        }
        [self.chatDataArray addObjectsFromArray:resultArr];
        
        [self addMainView];
        [self requestTopComHistories:YES];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestTopComHistories:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.topComHistoriesParam.page = 1;
    }else{
        self.topComHistoriesParam.page ++;
    }
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    [RotRequest getTopComHistories:self.topComHistoriesParam Success:^(ArrayResponse *response) {
        [HUDProgressTool dismiss];
        if (isRefresh) {
            [self.dataArray removeAllObjects];
        }
        NSArray * rtcDetailListArr = response.data;
        
        NSMutableArray * resultArr = [NSMutableArray array];
        for (NSDictionary * resultDict in rtcDetailListArr) {
            HistoryTopModel * likeModel = [HistoryTopModel new];
            [likeModel setValuesForKeysWithDictionary:resultDict];
            
            [resultArr addObject:likeModel];
        }
        [self.dataArray addObjectsFromArray:resultArr];
        
        if (rtcDetailListArr.count<self.topComHistoriesParam.pagesize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
         [HUDProgressTool showOnlyText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - HistoryTopTableViewCellDelegate

- (void)praise:(NSInteger)commentId{
    [RadioRequest praiseCommentWithCommentId:(int)commentId success:^(NSDictionary * response) {
        [self requestTopComHistories:YES];
    } failure:^(NSError * error) {
        
    }];
}

- (void)topBtnClick:(HistoryTopModel *)topModel{
    TopComParam * topComParam = [TopComParam new];
    topComParam.chatId = self.topComHistoriesParam.chatId;
    topComParam.comId = topModel.comId;
    topComParam.comUid = topModel.uid;
    
    [RadioRequest setTopCom:topComParam success:^(NSDictionary * response){
        if ([[response objectForKey:@"status"] intValue] == 200){
            [self requestTopComHistories:YES];
        }else{
            [HUDProgressTool showErrorWithText:[response objectForKey:@"msg"]];
        }
    } failure:^(NSError * error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
    }];
}

#pragma mark - button事件
- (void)buttonSelected:(UIButton *)button{
    for (UIButton * btn in self.attendViewDict.allValues) {
        if (button.tag == btn.tag) {
            btn.selected = YES;
            self.topComHistoriesParam.chatId = button.tag;
        }else{
            btn.selected = NO;
        }
    }
    [self requestTopComHistories:YES];
}

- (void)rightBtnSelected{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType2;
    datePicker.isHiddenMiddleText = false;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {

    NSString * month = dateComponents.month<10?[NSString stringWithFormat:@"0%ld",dateComponents.month]:[NSString stringWithFormat:@"%ld",dateComponents.month];
    NSString * day = dateComponents.day<10?[NSString stringWithFormat:@"0%ld",dateComponents.day]:[NSString stringWithFormat:@"%ld",dateComponents.day];
    self.topComHistoriesParam.idate = [NSString stringWithFormat:@"%ld%@%@",dateComponents.year,month,day];
    [self requestTopComHistories:YES];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[HistoryTopTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    cell.topDelegate = self;
    cell.isHistoryTop = YES;
    [cell setTopModel:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

- (TopComHistoriesParam *)topComHistoriesParam{
    if (!_topComHistoriesParam) {
        _topComHistoriesParam = [TopComHistoriesParam new];
        _topComHistoriesParam.page = 1;
        _topComHistoriesParam.pagesize = 10;
        _topComHistoriesParam.idate = @"";
    }
    return _topComHistoriesParam;
}

- (NSMutableDictionary *)attendViewDict{
    if (!_attendViewDict) {
        _attendViewDict = [NSMutableDictionary dictionary];
    }
    return _attendViewDict;
}

- (NSMutableArray<GuessULikeModel *> *)chatDataArray{
    if (!_chatDataArray) {
        _chatDataArray = [NSMutableArray array];
    }
    return _chatDataArray;
}

- (NSMutableArray<HistoryTopModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStylePlain delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView registerNib:[UINib nibWithNibName:@"HistoryTopTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[HistoryTopTableViewCell cellReuseIdentifierInfo]];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestTopComHistories:NO];
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
