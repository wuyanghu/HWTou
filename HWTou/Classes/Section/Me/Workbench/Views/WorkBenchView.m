//
//  WorkBenchView.m
//  HWTou
//
//  Created by robinson on 2017/11/24.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "WorkBenchView.h"
#import "PublicHeader.h"

#define identify @"identify"
#define headerIdentify @"headerIdentify"

@interface WorkBenchView()<UITableViewDelegate,UITableViewDataSource>
{
    WorkType _workType;
}
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSArray * dataArray;
@end

@implementation WorkBenchView

- (instancetype)initWithFrame:(CGRect)frame workType:(WorkType)workType detailModel:(TopicWorkDetailModel *)detailModel{
    self = [super initWithFrame:frame];
    if (self) {
        _workType = workType;
        _detailModel = detailModel;
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
//        if (_workType == workBenchType) {
//            return 192;
//        }else{
//            return 110;
//        }
        return kMainScreenWidth * 135/375.0;
    }
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        BaseWorkHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentify];
        [headerView setDetailModel:self.detailModel];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_workBenchViewDelegate didSelectRowAtIndexPath:indexPath workType:_workType title:self.dataArray[indexPath.section][indexPath.row]];
}

#pragma mark - getter

- (NSArray *)dataArray{
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    if (_workType == workBenchType) {
//        [dataArray addObject:@[@"我的话题",@"创建话题"]];
        
        if (self.detailModel.isChatAnchor == 1) {
            NSArray * tempDataArr = @[@"我的聊吧",@"直播记录"];
            [dataArray addObject:tempDataArr];
            
            NSArray * tempDataArr2 = @[@"我的收益"];
            [dataArray addObject:tempDataArr2];
        }
        
        if (self.detailModel.isChatM == 1) {
            NSArray * tempDataArr = @[@"管理聊吧",@"永久禁言"];
            [dataArray addObject:tempDataArr];
        }
        
        if (self.detailModel.isChannelM == 1) {
            NSArray * tempDataArr = @[@"管理广播"];
            [dataArray addObject:tempDataArr];
        }
        
    }else if (_workType == workBroadcastType){
        [dataArray addObject:@"我的电台"];
        if (!self.detailModel.isTopicM) {
            [dataArray addObject:@"申请主播"];
        }
    }else if (_workType == workChatType){
        if (self.detailModel.isChatAnchor == 1) {
            [dataArray addObject:@[@"我的聊吧",@"直播记录"]];
            
            NSArray * tempDataArr2 = @[@"我的收益"];
            [dataArray addObject:tempDataArr2];
        }
        
        if (self.detailModel.isChatM == 1) {
            NSArray * tempDataArr = @[@"管理聊吧",@"永久禁言"];
            [dataArray addObject:tempDataArr];
        }
        
    }
    [dataArray addObject:@[@"聊吧主播使用手册"]];
    
    _dataArray = dataArray;
    
    return _dataArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:self.frame style:UITableViewStylePlain delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identify];
//        if (_workType == workBenchType) {
//            [_tableView registerClass:[WorkBenchHeaderView class] forHeaderFooterViewReuseIdentifier:headerIdentify];
//        }else{
//            [_tableView registerClass:[BaseWorkHeaderView class] forHeaderFooterViewReuseIdentifier:headerIdentify];
//        }
        [_tableView registerClass:[BaseWorkHeaderView class] forHeaderFooterViewReuseIdentifier:headerIdentify];
    }
    return _tableView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation BaseWorkHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self drawView];
    }
    return self;
}

- (void)drawView{
    
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(kMainScreenWidth * 135/375.0);
    }];
    
    [self.bgView addSubview:self.headerImageView];
    [self.bgView addSubview:self.nicknameLabel];
    [self.bgView addSubview:self.timeLabel];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(70, 70));
        make.left.equalTo(self).offset(30);
        make.top.equalTo(self).offset(20);
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(15);
        make.left.equalTo(self.headerImageView.mas_right).offset(10);
        make.top.equalTo(self.headerImageView).offset(25);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(10);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(5);
        make.size.equalTo(CGSizeMake(140, 14));
    }];
}

- (void)setDetailModel:(TopicWorkDetailModel *)detailModel{
    _detailModel = detailModel;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.avater]];
    self.nicknameLabel.text = detailModel.nickname;
    self.timeLabel.text = [NSString stringWithFormat:@"%@加入",detailModel.joinDate];
}

#pragma mark - getter

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bgIV = [[UIImageView alloc] init];
        bgIV.image = [UIImage imageNamed:@"gzt_img_bg"];
        [_bgView addSubview:bgIV];
        
        [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_bgView);
            make.left.equalTo(_bgView);
            make.top.equalTo(_bgView);
        }];
    }
    return _bgView;
}

- (UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [BasisUITool getImageViewWithImage:PUBLIC_IMG_SYSTEM_AVATAR withIsUserInteraction:NO];
        [_headerImageView setContentMode:UIViewContentModeScaleAspectFill];
        CAShapeLayer *shape = [BasisUITool headPortraitRoundProcessing:70];
        [_headerImageView.layer setMask:shape];
    }
    return _headerImageView;
}


- (UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xffffff) size:15];
    }
    return _nicknameLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xffffff) size:12];
    }
    return _timeLabel;
}

@end

@implementation WorkBenchHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIView * bottomBgView = [[UIView alloc] init];
        bottomBgView.backgroundColor = UIColorFromHex(0xffffff);
        [self addSubview:bottomBgView];
        
        [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.bgView.mas_bottom);
        }];
        
        workBenchHeaderPlayView = [[WorkBenchHeaderPlayView alloc] init];
        [self addSubview:workBenchHeaderPlayView];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromHex(0x8e8f91);
        [self addSubview:lineView];
        
        workBenchHeaderPlay2View = [[WorkBenchHeaderPlayView alloc] init];
        [self addSubview:workBenchHeaderPlay2View];
        
        UIView * line2View = [[UIView alloc] init];
        line2View.backgroundColor = UIColorFromHex(0x8e8f91);
        [self addSubview:line2View];
        
        workBenchHeaderPlay3View = [[WorkBenchHeaderPlayView alloc] init];
        [self addSubview:workBenchHeaderPlay3View];
        
        [workBenchHeaderPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.bgView.mas_bottom);
            make.bottom.equalTo(self);
            make.width.equalTo(kMainScreenWidth/3);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(0.5);
            make.top.equalTo(bottomBgView).offset(13);
            make.bottom.equalTo(bottomBgView).offset(-10);
            make.left.equalTo(workBenchHeaderPlayView.mas_right);
        }];
        
        [workBenchHeaderPlay2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(workBenchHeaderPlayView.mas_right);
            make.top.equalTo(self.bgView.mas_bottom);
            make.bottom.equalTo(self);
            make.width.equalTo(kMainScreenWidth/3);
        }];
        
        [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(lineView);
            make.left.equalTo(workBenchHeaderPlay2View.mas_right);
        }];
        
        [workBenchHeaderPlay3View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(workBenchHeaderPlay2View.mas_right);
            make.top.equalTo(self.bgView.mas_bottom);
            make.bottom.equalTo(self);
            make.width.equalTo(kMainScreenWidth/3);
        }];
        
    }
    return self;
}

- (void)setDetailModel:(TopicWorkDetailModel *)detailModel{
    [super setDetailModel:detailModel];
    
    workBenchHeaderPlayView.lastPleyLabel.text = @"昨日播放";
    workBenchHeaderPlayView.lastPleyNumLabel.text = [NSString stringWithFormat:@"%ld",detailModel.preLookNum];
    workBenchHeaderPlayView.totalPlayLabel.text = [NSString stringWithFormat:@"总播放量 %ld",detailModel.allLookNum];
    
    workBenchHeaderPlay2View.lastPleyLabel.text = @"昨日收藏";
    workBenchHeaderPlay2View.lastPleyNumLabel.text = [NSString stringWithFormat:@"%ld",detailModel.preCollectNum];
    workBenchHeaderPlay2View.totalPlayLabel.text = [NSString stringWithFormat:@"总收藏量 %ld",detailModel.allCollectNum];
    
    workBenchHeaderPlay3View.lastPleyLabel.text = @"昨日收益";
    workBenchHeaderPlay3View.lastPleyNumLabel.text = [NSString stringWithFormat:@"%ld",detailModel.preTargetMoney];;
    workBenchHeaderPlay3View.totalPlayLabel.text = [NSString stringWithFormat:@"总收益额 %ld",detailModel.allTargetMoney];
}

@end

@implementation WorkBenchHeaderPlayView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.lastPleyLabel];
        [self addSubview:self.lastPleyNumLabel];
        [self addSubview:self.totalPlayLabel];
        
        [self.lastPleyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(44);
            make.top.equalTo(self).offset(16);
            make.height.equalTo(8);
            make.width.equalTo(40);
        }];
        
        [self.lastPleyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.lastPleyLabel);
            make.top.equalTo(self.lastPleyLabel.mas_bottom).offset(5);
        }];
        
        [self.totalPlayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.lastPleyNumLabel);
            make.top.equalTo(self.lastPleyNumLabel.mas_bottom).offset(10);
        }];
    }
    return self;
}

- (UILabel *)totalPlayLabel{
    if (!_totalPlayLabel) {
        _totalPlayLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x2b2b2b) size:10];
    }
    return _totalPlayLabel;
}

- (UILabel *)lastPleyNumLabel{
    if (!_lastPleyNumLabel) {
        _lastPleyNumLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0xf04a4d) size:18];
    }
    return _lastPleyNumLabel;
}

- (UILabel *)lastPleyLabel{
    if (!_lastPleyLabel) {
        _lastPleyLabel = [BasisUITool getLabelWithTextColor:UIColorFromHex(0x646665) size:10];
    }
    return _lastPleyLabel;
}
@end
