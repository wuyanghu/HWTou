//
//  MuteListTableViewCell.m
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "MuteListTableViewCell.h"
#import "PublicHeader.h"

@interface MuteListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *muteBtn;

@end

@implementation MuteListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onmuteAction:(id)sender {
    if (!self.muteBtn.selected) {
        [_cellDelegate onMuteAction:_itemDict button:(UIButton *)sender];
    }
}

- (void)setItemDict:(NSDictionary *)itemDict{
    _itemDict = itemDict;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_itemDict[@"avater"]]];
    self.nickNameLabel.text = _itemDict[@"nickName"];
}

@end
