//
//  BuildTopic.m
//  HWTou
//
//  Created by robinson on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BuildTopicView.h"
#import "PublicHeader.h"
#import "BuildTopicCarouselCell.h"

#define kIdentify0_0 @"kIdentify0_0"
#define kIdentify0_1 @"kIdentify0_1"
#define kIdentify0_2 @"kIdentify0_2"
#define kIdentify1_0 @"kIdentify1_0"
#define kIdentify1_1 @"kIdentify1_1"

@interface BuildTopicView()<UITableViewDelegate,UITableViewDataSource,TopicButtonSelectedDelegate>
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation BuildTopicView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        UIImage * bgImage = [UIImage imageNamed:@"bg_img_1"];
        _vCarouselImgArr = @[bgImage];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * heightArr = @[@[@(260),@(60),@(44)],@[@(44),@(208)]];
    NSNumber * heightNum = heightArr[indexPath.section][indexPath.row];
    return [heightNum integerValue];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 20)];
    bgView.backgroundColor = UIColorFromHex(0xF3F4F6);
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BuildTopicCarouselCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kIdentify0_0 forIndexPath:indexPath];
            [cell setVCarouselImgArr:_vCarouselImgArr];
            return cell;
        }else if (indexPath.row == 1){
            EnterEditCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kIdentify0_1 forIndexPath:indexPath];
            cell.btnDelegate = self;
            return cell;
        }else{
            UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kIdentify0_2 forIndexPath:indexPath];
            if ([_labelTitle isEqualToString:@""] || _labelTitle == nil) {
                cell.textLabel.text = @"请选择您的话题标签";
            }else{
                cell.textLabel.text = _labelTitle;
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            InputTitleCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kIdentify1_0 forIndexPath:indexPath];
            return cell;
        }else{
            ShareContentCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kIdentify1_1 forIndexPath:indexPath];
            return cell;
        }
    }
}

- (void)setVCarouselImgArr:(NSArray *)vCarouselImgArr{
    _vCarouselImgArr = vCarouselImgArr;
    [self.tableView reloadData];
}

- (void)setLabelTitle:(NSString *)labelTitle{
    _labelTitle = labelTitle;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_topicDelegate didSelectRowAtIndexPath:indexPath];
}

- (void)buttonSelected:(UIButton *)button{
    [_btnDelegate buttonSelected:button];
}
//标题
- (NSString *)getTitle{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    InputTitleCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    return cell.textField.text ? cell.textField.text : @"";
}

//分享内容
- (NSString *)shareContent{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    ShareContentCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell.textView.text ? cell.textView.text : @"";
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [BasisUITool getTableViewWithFrame:CGRectZero style:UITableViewStylePlain delegate:self dataSource:self scrollEnabled:YES separatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView registerClass:[BuildTopicCarouselCell class] forCellReuseIdentifier:kIdentify0_0];
        [_tableView registerClass:[EnterEditCell class] forCellReuseIdentifier:kIdentify0_1];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kIdentify0_2];
        [_tableView registerClass:[InputTitleCell class] forCellReuseIdentifier:kIdentify1_0];
        [_tableView registerClass:[ShareContentCell class] forCellReuseIdentifier:kIdentify1_1];
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
