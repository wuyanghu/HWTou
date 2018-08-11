//
//  ProductAttributeView.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/29.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "ProductAttributeView.h"
#import "XQNumCalculateView.h"
#import "ProductDetailDM.h"
#import "PublicHeader.h"

@interface ProductAttributeView () <UITableViewDataSource, UITableViewDelegate>
{
    UIImageView     *_imgvIcon;
    UILabel         *_labPrompt;
    UILabel         *_labPrice;
    
    UILabel         *_labNumber;
    XQNumCalculateView *_vCalculate;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ProductAttributeView

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
    self.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
    _imgvIcon = [[UIImageView alloc] init];
    
    _labPrice  = [self createLabel:nil fontSize:15.0f];
    _labPrompt = [self createLabel:@"请选择规格属性" fontSize:15.0f];
    _labNumber = [self createLabel:@"数量" fontSize:15.0f];
    
    _labPrice.textColor = UIColorFromHex(0xb4292d);
    
    _vCalculate = [[XQNumCalculateView alloc] init];
    _vCalculate.numViewBorderColor = UIColorFromHex(0x7f7f7f);
    _vCalculate.numColor = UIColorFromHex(0x333333);
    _vCalculate.numLabelTextFont = FontPFLight(13.0f);
    _vCalculate.calBtnDisabledTextColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    _vCalculate.calBtnTextColor = UIColorFromHex(0x333333);
    _vCalculate.calBtnTextFont = FontPFLight(15.0f);
    
    [self addSubview:_imgvIcon];
    [self addSubview:_labPrice];
    [self addSubview:_labPrompt];
    [self addSubview:_labNumber];
    [self addSubview:_vCalculate];
    
    [_imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(15.0f);
        make.top.equalTo(20.0f);
        make.size.equalTo(CGSizeMake(90, 90));
    }];
    
    [_labPrompt makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvIcon.trailing).offset(8);
        make.bottom.equalTo(_imgvIcon);
    }];
    
    [_labPrice makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_labPrompt);
        make.bottom.equalTo(_labPrompt.top);
    }];
    
    [_labNumber makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvIcon);
        make.top.equalTo(_imgvIcon.bottom).offset(20);
    }];
    
    [_vCalculate makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgvIcon);
        make.top.equalTo(_labNumber.bottom).offset(8);
        make.size.equalTo(CGSizeMake(160, 36));
    }];
}

- (void)setChangeBlock:(ProductNumberChangeBlock)changeBlock
{
    _changeBlock = changeBlock;
    _vCalculate.changeBlock = changeBlock;
}

- (void)setStartNum:(int)startNum
{
    _startNum = startNum;
    _vCalculate.startNum = startNum;
}

- (UILabel *)createLabel:(NSString *)text fontSize:(CGFloat)size
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromHex(0x333333);
    label.font = FontPFRegular(size);
    label.text = text;
    return label;
}

- (void)setDmProduct:(ProductDetailDM *)dmProduct
{
    _labPrice.text = dmProduct.strPrice;
    _vCalculate.maxNum = (int)dmProduct.stock;
    [_imgvIcon sd_setImageWithURL:[NSURL URLWithString:dmProduct.img_url]];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    return cell;
}
@end
