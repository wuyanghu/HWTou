//
//  CommonTableViewCell.m
//
//  Created by pengpeng on 15/10/23.
//  Copyright (c) 2015年 PP. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "PublicHeader.h"
#import "CommonTable.h"

@interface CommonTableViewCell () <UITextFieldDelegate>

/** 箭头 */
@property (nonatomic, strong) UIImageView       *imgvArrow;

/** 开关 */
@property (nonatomic, strong) UISwitch          *switchRight;

/** 标签 */
@property (nonatomic, strong) UILabel           *rightLabel;

/** 中间内容 */
@property (nonatomic, strong) UILabel           *labContent;

/** 文本输入 */
@property (nonatomic, strong) UITextField       *textField;

/** Cell数据模型 */
@property (nonatomic, strong) TableCellItem     *cellItem;

/** 自定义线条 */
@property (nonatomic, strong) UIView            *customSeparator;

@end

@implementation CommonTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.cellItem isKindOfClass:[TableCellTextFieldItem class]])
    {
        CGFloat coordX = self.cellItem.textCoordX;
        if (coordX <= 0)
        {
            coordX = CGRectGetMaxX(self.textLabel.frame) + 20.0f;
        }
        CGFloat width  = CGRectGetWidth(self.frame) - coordX - 15.0f;
        self.textField.frame = CGRectMake(coordX, 0, width, CGRectGetHeight(self.frame));
    }
    else if ([self.cellItem isKindOfClass:[TableCellCustomItem class]])
    {
        TableCellCustomItem *item = (TableCellCustomItem *)self.cellItem;
        CGFloat coordX = self.cellItem.textCoordX;
        if (coordX <= 0)
        {
            if (self.cellItem.subTitle.length > 0)
            {
                coordX = MAX(CGRectGetMaxX(self.textLabel.frame), CGRectGetMaxX(self.detailTextLabel.frame)) + 20.0f;
            }
            else
            {
                coordX = CGRectGetMaxX(self.textLabel.frame) + 20.0f;
            }
        }
        CGFloat width = CGRectGetWidth(self.frame) - coordX;
        item.viewCustom.frame = CGRectMake(coordX, 0, width, CGRectGetHeight(self.frame) - 1);
    }
    
    if (self.cellItem.textCenter.length > 0)
    {
        CGFloat coordX = self.cellItem.textCoordX;
        if (coordX <= 0)
        {
            coordX = CGRectGetMaxX(self.textLabel.frame) + 20.0f;
        }
        CGFloat width  = CGRectGetWidth(self.frame) - coordX - 15.0f - (self.accessoryView ? 12 : 0);
        self.labContent.frame = CGRectMake(coordX, 0, width, CGRectGetHeight(self.frame));
    }
    
    if (self.cellItem.subTitle.length > 0 && self.cellItem.subTitleSpace != 0)
    {
        CGRect frameTitle = self.textLabel.frame;
        frameTitle.origin.y -= self.cellItem.subTitleSpace/2;
        self.textLabel.frame = frameTitle;
        
        CGRect frameDetail = self.detailTextLabel.frame;
        frameDetail.origin.y += self.cellItem.subTitleSpace/2;
        self.detailTextLabel.frame = frameDetail;
    } else {
        CGRect frameDetail = self.detailTextLabel.frame;
        frameDetail.origin.x += self.cellItem.subTitleSpace;
        self.detailTextLabel.frame = frameDetail;
    }
}

#pragma mark - cell高亮和选中
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - 懒加载右边的view
- (UIImageView *)rightArrow
{
    if (_imgvArrow == nil)
    {
        _imgvArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_cell_arrow"]];
    }
    return _imgvArrow;
}

- (UISwitch *)switchRight
{
    if (_switchRight == nil)
    {
        _switchRight = [[UISwitch alloc] init];
        [_switchRight addTarget:self action:@selector(onClickSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchRight;
}

- (UILabel *)rightLabel
{
    if (_rightLabel == nil)
    {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor lightGrayColor];
        _rightLabel.font = [UIFont systemFontOfSize:13];
    }
    return _rightLabel;
}

- (UILabel *)labContent
{
    if (_labContent == nil)
    {
        _labContent = [[UILabel alloc] init];
#if 1
        _labContent.textColor = UIColorFromHex(0x333333);
        _labContent.font = FontPFRegular(14.0f);
#else
        _labContent.textColor = [UIColor blackColor];
        _labContent.font = [UIFont systemFontOfSize:14.0f];
#endif
        [self addSubview:_labContent];
    }
    return _labContent;
}

- (UIView *)customSeparator
{
    if (_customSeparator == nil)
    {
        _customSeparator = [[UIView alloc] init];
        _customSeparator.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    }
    
    return _customSeparator;
}

- (UITextField *)textField
{
    if (_textField == nil)
    {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:15.0f];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _textField;
}
#pragma mark - Init Method
+ (instancetype)cellWithTableView:(UITableView *)tableView cellItem:(TableCellItem *)cellItem
{
    static NSString *cellIDSubtitle = @"cellIDSubtitle";
    static NSString *cellIDValue1   = @"cellIDValue1";
    
    UITableViewCellStyle cellStyle = UITableViewCellStyleValue1;
    NSString *cellIdentifier = cellIDValue1;
    
    if (cellItem.subTitle.length > 0)
    {
        cellStyle = UITableViewCellStyleSubtitle;
        cellIdentifier = cellIDSubtitle;
    }
    
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[CommonTableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
    }
    cell.cellItem = cellItem;
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    // 设置标题的字体
#if 1
    // 杭文投项目定制
    self.textLabel.font = FontPFRegular(14.0f);
    self.textLabel.textColor = UIColorFromHex(0x7f7f7f);
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
#else
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
#endif
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self addSubview:self.customSeparator];
    self.customSeparator.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.customSeparator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.customSeparator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.customSeparator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-0.5];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.customSeparator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.5];
    
    NSArray *constraints = @[leftConstraint, rightConstraint, bottomConstraint, heightConstraint];
    [self addConstraints:constraints];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Setter & Getter
- (void)setCellItem:(TableCellItem *)cellItem
{
    _cellItem = cellItem;
    
    // 设置基本数据
    if (cellItem.icon.length > 0)
    {
        self.imageView.image = [UIImage imageNamed:cellItem.icon];
    }
    
    self.textLabel.text  = cellItem.title;
    if (cellItem.titleAttributed) {
        self.textLabel.attributedText = cellItem.titleAttributed;
    }
    self.detailTextLabel.text = cellItem.subTitle ?: cellItem.detailTitle;
    self.detailTextLabel.textColor = cellItem.detailTitleColor ? : [UIColor grayColor];
    
    if (cellItem.textCenter.length > 0) {
        self.labContent.text = cellItem.textCenter;
        self.labContent.textColor = cellItem.textCenterColor ? : [UIColor blackColor];
        self.labContent.numberOfLines = cellItem.centerNumberOfLines;
    } else {
        _labContent.text = nil;
    }
    
    [self setAccessoryViewWithCellItem:cellItem];
}

#pragma mark - Private Method
- (void)setAccessoryViewWithCellItem:(TableCellItem *)cellItem
{
    // 根据模型设置右边显示
    if ([cellItem isKindOfClass:[TableCellArrowItem class]])
    {
        self.accessoryView = self.rightArrow;
    }
    else if ([cellItem isKindOfClass:[TableCellSwitchItem class]])
    {
        TableCellSwitchItem *item = (TableCellSwitchItem *)cellItem;
        if (item.onTintColor)
        {
            self.switchRight.onTintColor = item.onTintColor;
        }
        self.switchRight.on = item.isOn;
        self.accessoryView = self.switchRight;
    }
    else if ([cellItem isKindOfClass:[TableCellLabelItem class]])
    {
        TableCellLabelItem *item = (TableCellLabelItem *)cellItem;
        self.rightLabel.text = item.textRight;
        self.labContent.text = item.textCenter;
        // 根据文字计算尺寸
        NSDictionary *dictAttributes = @{NSFontAttributeName : self.rightLabel.font};
        
        CGRect frame = {CGPointZero, [item.textRight sizeWithAttributes:dictAttributes]};
        self.rightLabel.frame = frame;
        self.accessoryView = self.rightLabel;
    }
    else if ([cellItem isKindOfClass:[TableCellTextFieldItem class]])
    {
        self.accessoryView = self.textField;
        
        TableCellTextFieldItem *item = (TableCellTextFieldItem *)cellItem;
        self.textField.placeholder = item.placeholder;
        self.textField.text = item.text;
        self.textField.enabled = !item.isDisableEdit;
        self.textField.secureTextEntry = item.secureTextEntry;
        self.textField.keyboardType = item.keyboardType;
        
        if (item.textColor)
        {
            self.textField.textColor = item.textColor;
        }
    }
    else if ([cellItem isKindOfClass:[TableCellCustomItem class]])
    {
        TableCellCustomItem *item = (TableCellCustomItem *)cellItem;
        self.accessoryView = item.viewCustom;
    }
    else
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = nil;
    }
    
    if (cellItem.isSelectionState)
    {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    self.customSeparator.hidden = cellItem.isHideSeparator;
}

#pragma mark - Event Handle
- (void)onClickSwitchEvent:(UISwitch *)aSwitch
{
    TableCellSwitchItem *item = (TableCellSwitchItem *)self.cellItem;
    
    if (item.cellClickSwitchHandle)
    {
        item.cellClickSwitchHandle(aSwitch.isOn);
    }
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    TableCellTextFieldItem *item = (TableCellTextFieldItem *)self.cellItem;
    
    if (item.textMaxLength > 0)
    {
        NSString *language = [[UIApplication sharedApplication].textInputMode primaryLanguage];
        if ([language isEqualToString:@"zh-Hans"])
        {
            UITextRange *markedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:markedRange.start offset:0];
            
            if (!position)
            {
                if (textField.text.length > item.textMaxLength) {
                    textField.text = [textField.text substringToIndex:item.textMaxLength];
                }
            }
        }
        else
        {
            if (textField.text.length > item.textMaxLength) {
                textField.text = [textField.text substringToIndex:item.textMaxLength];
            }
        }
    }
    
    if (item.cellTextFieldChanged)
    {
        item.cellTextFieldChanged(textField.text);
    }
    
    if (item.cellTextReplaceChanged)
    {
        textField.text = item.cellTextReplaceChanged(textField.text);
    }

    item.text = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    TableCellTextFieldItem *item = (TableCellTextFieldItem *)self.cellItem;
    if (item.textMaxLength > 0)
    {
        if (textField.text.length >= item.textMaxLength && string.length > 0)
        {
            return NO;
        }
    }
    return YES;
}

@end
