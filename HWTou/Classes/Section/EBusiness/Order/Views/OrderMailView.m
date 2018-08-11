//
//  OrderMailView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "OrderMailView.h"
#import "PublicHeader.h"
#import "OrderMailCell.h"
#import "OrderMailReq.h"

@interface OrderMailView () <UITableViewDataSource, UITableViewDelegate>
{
    UILabel     *_labMailName;
    UILabel     *_labMailNo;
}

@property (nonatomic, copy) NSArray *listData;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation OrderMailView

static  NSString * const kCellIdentifier = @"CellIdentifier";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = UIColorFromHex(0xf4f4f4);
    
    UIImageView *imgvMapBG = [[UIImageView alloc] init];
    imgvMapBG.image = [UIImage imageNamed:@"shop_mail_map_bg"];
    
    _labMailName = [[UILabel alloc] init];
    _labMailName.textColor = UIColorFromHex(0x333333);
    _labMailName.font = FontPFRegular(14.0f);
    
    _labMailNo = [[UILabel alloc] init];
    _labMailNo.textColor = UIColorFromHex(0x333333);
    _labMailNo.font = FontPFRegular(14.0f);
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    [self.tableView registerClass:[OrderMailCell class] forCellReuseIdentifier:kCellIdentifier];
    
    [self addSubview:imgvMapBG];
    [self addSubview:self.tableView];
    
    [imgvMapBG addSubview:_labMailName];
    [imgvMapBG addSubview:_labMailNo];
    
    [_labMailName makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(16);
        make.top.equalTo(12);
    }];
    
    [_labMailNo makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_labMailName);
        make.bottom.equalTo(imgvMapBG).offset(-12);
    }];
    
    [imgvMapBG makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@65);
    }];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.leading.equalTo(self);
        make.top.equalTo(imgvMapBG.bottom);
    }];
}

- (void)setDmMail:(OrderMailResult *)dmMail
{
    _labMailNo.text = [NSString stringWithFormat:@"物流单号: %@", dmMail.mail_no];
    _labMailName.text = [NSString stringWithFormat:@"物流公司: %@", dmMail.company_name];
    self.listData = dmMail.list;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderMailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell setDmMail:self.listData[indexPath.row]];
    [cell setCellRow:indexPath.row total:self.listData.count];
    return cell;
}
@end
