//
//  AddSetMusicDetailViewController.m
//  HWTou
//
//  Created by robinson on 2018/3/20.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AddSetMusicDetailViewController.h"
#import "PublicHeader.h"
#import "RotRequest.h"
#import "AddsetMusicTableViewCell.h"
#import "AddSetMusicViewProtocol.h"
#import "NTESLiveUtil.h"
#import "HSDownloadManager.h"

@interface AddSetMusicDetailViewController ()<AddsetMusicTableViewCellDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation AddSetMusicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"添加配乐"];
    
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
    
    [HUDProgressTool showIndicatorWithText:ReqLoadingIn];
    GetChatBmgParam * chatBmgParam = [GetChatBmgParam new];
    chatBmgParam.labelId = _labelId;
    chatBmgParam.flag = 1;
    [RotRequest getChatBmg:chatBmgParam Success:^(ArrayResponse *response) {
        [HUDProgressTool dismiss];
        if (response.status == 200) {
            NSArray * rtcDetailListArr = response.data;
            [self.dataArray addObjectsFromArray:rtcDetailListArr];
            [self.tableView reloadData];
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
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddsetMusicTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[AddsetMusicTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    cell.cellDelegate = self;
    NSDictionary * item = self.dataArray[indexPath.row];
    cell.itemDict = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - AddsetMusicTableViewCell

- (void)downLoadAction:(NSDictionary *)itemDict{
    [NTESLiveUtil liveSetMusicSave:itemDict];
    
    [[HSDownloadManager sharedInstance] download:itemDict[@"bmgUrl"] progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * downProgress = [NSString stringWithFormat:@"%.f%%", progress * 100];
            NSLog(@"下载进度%@",downProgress);
        });
    } state:^(DownloadState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"下载完成");
        });
    }];
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
        [_tableView registerNib:[UINib nibWithNibName:@"AddsetMusicTableViewCell" bundle:nil]
             forCellReuseIdentifier:[AddsetMusicTableViewCell cellReuseIdentifierInfo]];
    }
    return _tableView;
}

@end
