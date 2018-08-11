//
//  TopicTitleScrollView.m
//  HWTou
//
//  Created by robinson on 2018/1/19.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "TopicTitleScrollView.h"
#import "PublicHeader.h"

@interface TopicTitleScrollView()
{
    NSInteger labelWidth;
}
@property (nonatomic,strong) NSMutableDictionary * labelDict;
@property (nonatomic,strong) UIButton * arrowButton;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIView * bgView;
@end

@implementation TopicTitleScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        labelWidth = kMainScreenWidth/5;
        
        [self addSubview:self.bgView];
        
        [self addSubview:self.scrollView];
        [self addSubview:self.arrowButton];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self showScrollArrow:_dataArray];
    

//    UIView * lineView = [[UIView alloc] init];
//    lineView.backgroundColor = UIColorFromHex(0xAD0021);
//    
//    [self addSubview:lineView];
//    
//    lineView.frame = CGRectMake(0, 43, kMainScreenWidth/5, 1);
    
}

- (void)setAllDataArray:(NSArray<TopicLabelListModel *> *)allDataArray{
    _allDataArray = allDataArray;
}

//展示所有数据
- (void)showAllArrow{
    
    self.arrowButton.hidden = YES;
    self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.bgView.frame = self.frame;
    self.scrollView.frame = CGRectMake(0, 0, kMainScreenWidth, 44*(self.allDataArray.count/5+1));
    self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, self.frame.size.height);
    
    [self drawBtn:self.allDataArray];
    
    for (int i = 0;i< self.allDataArray.count;i++) {
        TopicLabelListModel * listModel = self.allDataArray[i];
        NSString * keyUid = [NSString stringWithFormat:@"%ld",listModel.labelId];
        UIButton * tempBtn = self.labelDict[keyUid];
        NSUInteger row = i/5;
        NSUInteger col = i%5;
        tempBtn.frame = CGRectMake(col*labelWidth, row*44, labelWidth, 44);
    }
}
//展示滚动的数据
- (void)showScrollArrow:(NSArray *)dataArray{
    self.arrowButton.hidden = NO;
    self.frame = CGRectMake(0, 0, kMainScreenWidth, 44);
    self.scrollView.frame = CGRectMake(0, 0, kMainScreenWidth-44, 44);
    self.scrollView.contentSize = CGSizeMake(labelWidth * dataArray.count, 44);
    self.bgView.frame = CGRectZero;
    [self drawBtn:dataArray];
}

- (void)drawBtn:(NSArray *)dataArray{
    UIButton * firstBtn;
    if (self.labelDict.count != dataArray.count) {
        for (UIButton * tempBtn in self.labelDict.allValues) {
            [tempBtn removeFromSuperview];
        }
        [self.labelDict removeAllObjects];
    }
    
    for (int i = 0;i<dataArray.count;i++) {
        TopicLabelListModel * secsModel = dataArray[i];
        NSString * keyUid = [NSString stringWithFormat:@"%ld",secsModel.labelId];
        UIButton * tempBtn = self.labelDict[keyUid];
        if (tempBtn == nil) {
            tempBtn = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
            tempBtn.tag = secsModel.labelId;
            [tempBtn setTitleColor:UIColorFromHex(0x2b2b2b) forState:UIControlStateNormal];
            [tempBtn setTitleColor:UIColorFromHex(0xAD0021) forState:UIControlStateSelected];
            tempBtn.backgroundColor = UIColorFromHex(0xF3F4F6);
            [self.scrollView addSubview:tempBtn];
            
            if (firstBtn == nil) {
                tempBtn.frame = CGRectMake(0, 0, labelWidth, 44);
            }else{
                tempBtn.frame = CGRectMake(firstBtn.frame.origin.x+firstBtn.frame.size.width, firstBtn.frame.origin.y, labelWidth, 44);
            }
            
            firstBtn = tempBtn;
        }else{
            tempBtn.frame = CGRectMake(i*labelWidth, 0, labelWidth, 44);
        }
        [firstBtn setTitle:secsModel.labelName forState:UIControlStateNormal];
        tempBtn.selected = dataArray[_selectedTopicLabelIndex]==secsModel;
        [self.labelDict setObject:tempBtn forKey:keyUid];
        
    }
}

- (void)setSeletedLabel:(NSInteger)tag{
    for (int i = 0;i<self.allDataArray.count;i++) {
        TopicLabelListModel * secsModel = self.allDataArray[i];
        if (secsModel.labelId == tag) {
            _selectedTopicLabelIndex = i;
        }
    }
    
    [self showScrollArrow:_allDataArray];
}

- (void)buttonSelected:(UIButton *)button{
    if (button.tag == arrowsBtnType) {
        [self showAllArrow];
    }else{
        [self setSeletedLabel:button.tag];
        if (_selectedDelegate) {
            [_selectedDelegate selectedLabelTopic:_selectedTopicLabelIndex];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch * touch = touches.anyObject;
//    CGPoint location = [touch locationInView:self];
//    NSLog(@"%.f,%.f",location.x,location.y);
    [self showScrollArrow:_dataArray];
}

#pragma mark - getter

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColorFromHex(0x000000);
        _bgView.alpha = 0.4;
    }
    return _bgView;
}

- (UIButton *)arrowButton{
    if (!_arrowButton) {
        _arrowButton = [BasisUITool getNormalBtnWithTarget:self action:@selector(buttonSelected:)];
        _arrowButton.frame = CGRectMake(kMainScreenWidth-44, 0, 44, 44);
        [_arrowButton setImage:[UIImage imageNamed:@"open_red"] forState:UIControlStateNormal];
        [_arrowButton setImage:[UIImage imageNamed:@"close_red"] forState:UIControlStateSelected];
        [_arrowButton setBackgroundColor:[UIColor whiteColor]];
        _arrowButton.tag = arrowsBtnType;
    }
    return _arrowButton;
}

- (NSMutableDictionary *)labelDict{
    if (!_labelDict) {
        _labelDict = [NSMutableDictionary dictionary];
    }
    return _labelDict;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth-44, 44)];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
