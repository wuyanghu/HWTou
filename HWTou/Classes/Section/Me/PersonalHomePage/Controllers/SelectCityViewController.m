//
//  SelectCityViewController.m
//  HWTou
//
//  Created by robinson on 2017/11/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SelectCityViewController.h"
#import "PublicHeader.h"
#import "PersonHomeDM.h"
#import "PersonHomeReq.h"
#import "YYModel.h"

#define kCellIdentifier @"CellIdentifier"

@interface SelectCityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStylePlain delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    CityInfoModel * infoModel = self.dataArray[indexPath.row];
    cell.textLabel.text = infoModel.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityInfoModel * infoModel = self.dataArray[indexPath.row];
    //传0获取省份
    [CityInfoRequest getAllCityArea:infoModel.id success:^(CityInfoResponse *response) {
        NSMutableArray * cityArray = [NSMutableArray array];
        NSArray * dataArray = response.data;
        for (NSDictionary * dataDict in dataArray) {
            CityInfoModel * model = [CityInfoModel yy_modelWithDictionary:dataDict];
            [cityArray addObject:model];
        }
        if (cityArray.count == 0) {
            //返回选择的地址
        }else{
            //不等于0，继续选择
            SelectCityViewController * selectVC = [[SelectCityViewController alloc] init];
            [selectVC setDataArray:cityArray];
            [self.navigationController pushViewController:selectVC animated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
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
