//
//  FloorSecondView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "FloorSecondView.h"
#import "ComFloorEvent.h"
#import "PublicHeader.h"
#import "ComFloorDM.h"

@interface FloorSecondCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgvIcon;
@property (nonatomic, copy) NSString *strImgUrl;

@end

@implementation FloorSecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.imgvIcon = [[UIImageView alloc] init];
    [self addSubview:self.imgvIcon];
    [self.imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setStrImgUrl:(NSString *)strImgUrl
{
    _strImgUrl = strImgUrl;
    NSURL *url = [NSURL URLWithString:strImgUrl];
    [self.imgvIcon sd_setImageWithURL:url];
}

@end

@interface FloorSecondView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FloorSecondView

static NSString * const kCellIdentifier = @"CellIdentifier";

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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromHex(0xf4f4f4);
    self.tableView.rowHeight = kScale_9_16 * kMainScreenWidth;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[FloorSecondCell class] forCellReuseIdentifier:kCellIdentifier];
    
    [self addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setFloor:(FloorDataDM *)floor
{
    _floor = floor;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.floor.floorItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FloorSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    FloorItemDM *fItem = [self.floor.floorItems objectAtIndex:indexPath.section];
    [cell setStrImgUrl:fItem.img_url];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FloorItemDM *dmFloor = [self.floor.floorItems objectAtIndex:indexPath.section];
    [ComFloorEvent handleEventWithFloor:dmFloor];
}

@end
