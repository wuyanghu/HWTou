//
//  RadioTopHeaderCell.m
//  
//
//  Created by Reyna on 2017/11/26.
//

#import "RadioTopHeaderCell.h"
#import "PublicHeader.h"

@interface RadioTopHeaderCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *ru_headerIV;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *cp_headerIV;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *td_headerIV;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *ru_nameLab;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *cp_nameLab;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *td_nameLab;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *ru_numLab;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *cp_numLab;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *td_numLab;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *ru_infoLab;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *cp_infoLab;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *td_infoLab;

@end

@implementation RadioTopHeaderCell


+ (NSString *)cellReuseIdentifierInfo {
    return @"RadioTopHeaderCell";
}

- (void)bind:(RadioViewModel *)viewModel {
    if (viewModel.dataArr.count > 0) {
        RadioModel *cpM = [viewModel.dataArr objectAtIndex:0];
        [self.cp_headerIV sd_setImageWithURL:[NSURL URLWithString:cpM.channelImg]];
        self.cp_nameLab.text = cpM.channelName;
        self.cp_numLab.text = [NSString stringWithFormat:@"%d人",cpM.look];
        self.cp_infoLab.text = cpM.playing;
    }
    if (viewModel.dataArr.count > 1) {
        RadioModel *ruM = [viewModel.dataArr objectAtIndex:1];
        [self.ru_headerIV sd_setImageWithURL:[NSURL URLWithString:ruM.channelImg]];
        self.ru_nameLab.text = ruM.channelName;
        self.ru_numLab.text = [NSString stringWithFormat:@"%d人",ruM.look];
        self.ru_infoLab.text = ruM.playing;
    }
    if (viewModel.dataArr.count > 2) {
        RadioModel *tdM = [viewModel.dataArr objectAtIndex:2];
        [self.td_headerIV sd_setImageWithURL:[NSURL URLWithString:tdM.channelImg]];
        self.td_nameLab.text = tdM.channelName;
        self.td_numLab.text = [NSString stringWithFormat:@"%d人",tdM.look];
        self.td_infoLab.text = tdM.playing;
    }
}

+ (CGFloat)cellRatioHeight {
    return 250/375.f * kMainScreenWidth;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)UIColorFromHex(0x8111b0).CGColor, (__bridge id)UIColorFromHex(0x6660ea).CGColor];
    gradientLayer.locations = @[@0.5, @0.72, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, kMainScreenWidth, 250/375.f * kMainScreenWidth);
//    [self.contentView.layer addSublayer:gradientLayer];
    [self.contentView.layer insertSublayer:gradientLayer atIndex:0];
}

- (IBAction)topBtnAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topSelectBtnAction:)]) {
        [self.delegate topSelectBtnAction:sender.tag - 100];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
