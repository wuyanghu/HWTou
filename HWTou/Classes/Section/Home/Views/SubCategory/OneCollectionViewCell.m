//
//  OneCollectionViewCell.m
//  HWTou
//
//  Created by robinson on 2018/1/3.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "OneCollectionViewCell.h"
#import "PublicHeader.h"

@interface OneCollectionViewCell()

@property (nonatomic,strong) NSMutableDictionary * labelDict;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;

@end

@implementation OneCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setClassModel:(ChatClassesModel *)classModel{
    _classModel = classModel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:classModel.iconImg]];
     self.label.text = classModel.className;
    
    UIButton * firstBtn;
    if (self.labelDict.count != classModel.showArr.count) {
        for (UIButton * tempBtn in self.labelDict.allValues) {
            [tempBtn removeFromSuperview];
        }
        [self.labelDict removeAllObjects];
    }
    
    NSInteger labelWidth = (kMainScreenWidth-15)/4;
    for (ChatClassSecsModel * secsModel in classModel.showArr) {
        NSString * keyUid = [NSString stringWithFormat:@"%ld",secsModel.classIdSec];
        UIButton * tempBtn = self.labelDict[keyUid];
        if (tempBtn == nil) {
            tempBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
            tempBtn.tag = secsModel.classIdSec;
            [tempBtn setTitleColor:UIColorFromHex(0x2b2b2b) forState:UIControlStateNormal];
            tempBtn.backgroundColor = UIColorFromHex(0xF3F4F6);
            [self addSubview:tempBtn];
            
            if (firstBtn == nil) {
                tempBtn.frame = CGRectMake(95, 0, labelWidth, 45);
            }else{
                tempBtn.frame = CGRectMake(firstBtn.frame.origin.x+firstBtn.frame.size.width+5, firstBtn.frame.origin.y, labelWidth, 45);
                if (tempBtn.frame.origin.x+tempBtn.frame.size.width > kMainScreenWidth) {
                    tempBtn.frame = CGRectMake(95, firstBtn.frame.origin.y+firstBtn.frame.size.height+5, labelWidth, 45);
                }
            }
            
            firstBtn = tempBtn;
            
            if (secsModel.classIdSec == -1) {
                [firstBtn setImage:[UIImage imageNamed:@"open_red"] forState:UIControlStateNormal];
                [firstBtn setImage:[UIImage imageNamed:@"close_red"] forState:UIControlStateSelected];
                firstBtn.selected = !_classModel.isShowAll;
            }
        }
        if (secsModel.classIdSec != -1) {
            [firstBtn setTitle:secsModel.classNameSec forState:UIControlStateNormal];

        }
        
        [self.labelDict setObject:tempBtn forKey:keyUid];
        
    }
    
}

- (void)setOtherClassModel:(ChatClassesModel *)otherClassModel{
    self.bgViewWidth.constant = (kMainScreenWidth-15)/4;
    
    _otherClassModel = otherClassModel;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:otherClassModel.iconImg]];
    self.label.text = otherClassModel.className;
}

#pragma mark - action
- (void)buttonSelected:(UIButton *)button{
    for (ChatClassSecsModel * secsModel in _classModel.showArr) {
        if (secsModel.classIdSec == button.tag) {
            _actionBlock(secsModel);
            break;
        }
    }
}

#pragma mark - getter
- (NSMutableDictionary *)labelDict{
    if (!_labelDict) {
        _labelDict = [NSMutableDictionary dictionary];
    }
    return _labelDict;
}

#pragma mark - static

+ (NSString *)cellIdentity{
    return @"OneCollectionViewCell";
}

+ (NSString *)otherCellIdentity{
    return @"otherCellIdentity";
}
@end
