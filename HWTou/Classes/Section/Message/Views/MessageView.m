//
//  MessageView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/4/10.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MsgDetailViewController.h"
#import "PublicHeader.h"
#import "MessageView.h"
#import "MessageDM.h"

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) MessageDM *dmMessage;

@end

@interface MessageView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MessageView

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
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:kCellIdentifier];
    
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setListData:(NSArray *)listData
{
    _listData = listData;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell setDmMessage:self.listData[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MsgDetailViewController *detailVC = [[MsgDetailViewController alloc] init];
    [detailVC setDmMsg:self.listData[indexPath.section]];
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}

@end

@interface MessageCell ()
{
    UIView      *_vBadge;
    UILabel     *_labTitle;
    UILabel     *_labTime;
    UIImageView *_imgvArrow;
}
@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    _vBadge.backgroundColor = UIColorFromHex(0xb4292d);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    _vBadge.backgroundColor = UIColorFromHex(0xb4292d);
}

- (void)createUI
{
    _labTitle = [[UILabel alloc] init];
    _labTitle.textColor = UIColorFromHex(0x333333);
    _labTitle.font = FontPFRegular(15.0f);
    
    _labTime = [[UILabel alloc] init];
    _labTime.textColor = UIColorFromHex(0x333333);
    _labTime.font = FontPFRegular(13.0f);
    
    _vBadge = [[UIView alloc] init];
    [_vBadge setRoundWithCorner:4.0f];
    _vBadge.backgroundColor = UIColorFromHex(0xb4292d);
    
    _imgvArrow = [[UIImageView alloc] init];
    _imgvArrow.image = [UIImage imageNamed:@"public_cell_arrow"];
    
    [self addSubview:_labTitle];
    [self addSubview:_labTime];
    [self addSubview:_vBadge];
    [self addSubview:_imgvArrow];
    
    [_vBadge makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(10);
        make.centerY.equalTo(_labTitle);
        make.size.equalTo(CGSizeMake(8, 8));
    }];
    
    [_labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).multipliedBy(0.75);
        make.leading.equalTo(_vBadge.trailing).offset(6);
        make.trailing.lessThanOrEqualTo(_imgvArrow.leading).offset(-5);
    }];
    
    [_labTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labTitle.bottom).offset(5);
        make.leading.equalTo(_labTitle);
    }];
    
    [_imgvArrow makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_labTitle);
        make.trailing.equalTo(self).offset(-14);
        make.size.equalTo(CGSizeMake(8, 15));
    }];
}

- (void)setDmMessage:(MessageDM *)dmMessage
{
    _dmMessage = dmMessage;
    _labTitle.text = dmMessage.title;
    _labTime.text = dmMessage.create_time;
    _vBadge.hidden = dmMessage.status;
}
@end
