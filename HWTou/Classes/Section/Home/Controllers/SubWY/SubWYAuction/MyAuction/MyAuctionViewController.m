//
//  MyAuctionViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/23.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MyAuctionViewController.h"
#import "MyAuctionTableViewCell.h"
#import "AuctionOrderViewController.h"
#import "AuctionOrderStateViewController.h"

@interface MyAuctionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyAuctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"我的拍卖"];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyAuctionTableViewCell" bundle:nil]
         forCellReuseIdentifier:[MyAuctionTableViewCell cellReuseIdentifierInfo]];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * dataArray = @[@[@{@"icon":@"btn_icon_cpz",@"title":@"参拍中"},
                              @{@"icon":@"wanc",@"title":@"已拍中"},
                              @{@"icon":@"btn_icon_end",@"title":@"未拍中"},],
                            @[@{@"icon":@"btn_icon_money",@"title":@"我的保证金"},]
                            ];
    
    NSDictionary * itemDict = dataArray[indexPath.section][indexPath.row];
    
    MyAuctionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[MyAuctionTableViewCell cellReuseIdentifierInfo] forIndexPath:indexPath];
    [cell.iconImageView setImage:[UIImage imageNamed:itemDict[@"icon"]]];
    cell.titleLabel.text = itemDict[@"title"];
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
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AuctionOrderStateViewController * stateVC = [[AuctionOrderStateViewController alloc] init];
            stateVC.type = AuctionOrderStateTypeProceed;
            [self.navigationController pushViewController:stateVC animated:YES];
        }else if (indexPath.row == 1) {
            AuctionOrderViewController * auctionOrderVC = [[AuctionOrderViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:auctionOrderVC animated:YES];
        }else if (indexPath.row == 2){
            AuctionOrderStateViewController * stateVC = [[AuctionOrderStateViewController alloc] init];
            stateVC.type = AuctionOrderStateTypeNoGet;
            [self.navigationController pushViewController:stateVC animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            AuctionOrderStateViewController * stateVC = [[AuctionOrderStateViewController alloc] init];
            stateVC.type = AuctionOrderStateTypeMargin;
            [self.navigationController pushViewController:stateVC animated:YES];
        }
    }
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
