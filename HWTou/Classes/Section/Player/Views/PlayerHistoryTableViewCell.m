//
//  PlayerHistoryTableViewCell.m
//  HWTou
//
//  Created by robinson on 2017/12/27.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "PlayerHistoryTableViewCell.h"
#import "HorizontalListView.h"
#import "PublicHeader.h"

@implementation PlayerHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.listView];
        [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView);
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    // Configure the view for the selected state
    if (!self.editing) {
        return;
    }
    [super setSelected:selected animated:animated];
    
    if (self.editing) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.listView.backgroundColor = [UIColor clearColor];
        self.listView.titleLael.backgroundColor = [UIColor clearColor];
        self.listView.subTitleLael.backgroundColor = [UIColor clearColor];
        self.listView.playNumLabel.backgroundColor = [UIColor clearColor];
        //处理选中背景色问题
        UIView *backGroundView = [[UIView alloc]init];
        backGroundView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = backGroundView;
    }
}


-(void)layoutSubviews
{
    
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *view in control.subviews)
            {
                if ([view isKindOfClass: [UIImageView class]]) {
                    UIImageView *image=(UIImageView *)view;
                    if (self.selected) {
                        image.image=[UIImage imageNamed:@"selected_icon"];
                    }
                    else
                    {
                        //                        image.image=[UIImage imageNamed:@"CellButton"];
                    }
                }
            }
        }
    }
    
    [super layoutSubviews];
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
