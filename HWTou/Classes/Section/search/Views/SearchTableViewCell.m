//
//  SearchTableViewCell.m
//  HWTou
//
//  Created by robinson on 2017/12/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "HorizontalListView.h"
#import "PublicHeader.h"

@implementation SearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.listView];
        [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.width.equalTo(kMainScreenWidth);
            make.height.equalTo(90);
            make.bottom.equalTo(-5);
        }];
    
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)cellReuseIdentifierInfo{
    return @"SearchTableViewCell";
}

#pragma mark - getter

- (HorizontalListView *)listView{
    if (!_listView) {
        _listView = [[HorizontalListView alloc] init];
    }
    return _listView;
}

@end
