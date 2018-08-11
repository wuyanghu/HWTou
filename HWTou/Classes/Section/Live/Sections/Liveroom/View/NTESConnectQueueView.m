//
//  NTESConnectQueueView.m
//  NIMLiveDemo
//
//  Created by chris on 16/7/25.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESConnectQueueView.h"
#import "UIView+NTES.h"
#import "NIMAvatarImageView.h"
#import "NTESMicConnector.h"

@interface NTESConnectQueueCell : UICollectionViewCell

@property (nonatomic,strong) NIMAvatarImageView *avatar;

@property (nonatomic,strong) UILabel *nickLabel;

@property (nonatomic,strong) UIButton *button;

- (void)refresh:(NTESMicConnector *)connector;

@end

@interface NTESConnectQueueView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray<NTESMicConnector *> * _queue;
}

@property (nonatomic, strong) UIView *bar;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UICollectionView *waitingView;

@property (nonatomic,strong) UIImageView *emptyTipImageView;

@end

@implementation NTESConnectQueueView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 158.f)];
        [_bar setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_bar];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_titleLabel sizeToFit];
        [_bar addSubview:_titleLabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(40, 77);
        layout.minimumInteritemSpacing = 25.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _waitingView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 77) collectionViewLayout:layout];
        _waitingView.delegate = self;
        _waitingView.dataSource = self;
        _waitingView.backgroundColor = [UIColor clearColor];
        [_waitingView registerClass:[NTESConnectQueueCell class] forCellWithReuseIdentifier:@"cell"];
        [_waitingView setShowsHorizontalScrollIndicator:NO];
        [_bar addSubview:_waitingView];
        
        _emptyTipImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"icon_no_connector_sep"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10) resizingMode:UIImageResizingModeStretch]];
        _emptyTipImageView.ntesSize = CGSizeMake(frame.size.width, 2.5f);
        [_bar addSubview:_emptyTipImageView];
                
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)refreshWithQueue:(NSArray<NTESMicConnector *> *)queue
{
    _queue = queue;
    _titleLabel.text = queue.count? [NSString stringWithFormat:@"有%zd人想要连线", queue.count] : @"当前没有收到连线申请";
    [_titleLabel sizeToFit];
    _titleLabel.textColor = queue.count? UIColorFromRGB(0x333333) : UIColorFromRGB(0x999999);
    _emptyTipImageView.hidden = queue.count;
    [self setNeedsLayout];
}


- (void)onTapBackground:(UIButton *)button
{
    [self dismiss];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bar.ntesTop = self.ntesHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.ntesBottom = self.ntesHeight;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.ntesTop = self.ntesHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bar.ntesBottom = self.ntesHeight;
    
    CGFloat titleTop = _queue.count? 10.f : 45.f;
    self.titleLabel.ntesTop = titleTop;
    self.titleLabel.ntesCenterX = self.bar.ntesWidth * .5f;
    
    CGFloat spacing = 26.f;
    CGFloat left    = 15.f;
    self.waitingView.ntesTop  = self.titleLabel.ntesBottom + spacing;
    self.waitingView.ntesLeft = left;
    
    CGFloat gapping = 20.f;
    left    = 50.f;
    _emptyTipImageView.ntesTop = self.titleLabel.ntesBottom + gapping;
    _emptyTipImageView.ntesWidth = self.ntesWidth - left * 2;
    _emptyTipImageView.ntesCenterX = self.ntesWidth * .5f;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NTESMicConnector *connector = [_queue objectAtIndex:indexPath.row];
    if (!connector.isSelected) {
        connector.isSelected = YES;
        for (NTESMicConnector *con in _queue) {
            if (con != connector) {
                con.isSelected = NO;
            }
        }
        [collectionView reloadData];
    }
    else
    {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        if ([self.delegate respondsToSelector:@selector(onSelectMicConnector:)]) {
            [self.delegate onSelectMicConnector:connector];
        }
        [self dismiss];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _queue.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NTESConnectQueueCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NTESMicConnector *connector = [_queue objectAtIndex:indexPath.row];
    [cell refresh:connector];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end



@implementation NTESConnectQueueCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _avatar.userInteractionEnabled = NO;
        [self addSubview:_avatar];
        
        _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nickLabel.font = [UIFont systemFontOfSize:9];
        _nickLabel.textColor = UIColorFromRGB(0x999999);
        [self addSubview:_nickLabel];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundColor:UIColorFromRGB(0x238efa)];
        _button.titleLabel.font = [UIFont systemFontOfSize:9.f];
        [self addSubview:_button];
    }
    return self;
}

- (void)refresh:(NTESMicConnector *)connector
{
    self.nickLabel.text = connector.nick;
    [self.nickLabel sizeToFit];
    
    [self.avatar nim_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"avatar_user"]];
    
    NSString *buttonTitle = connector.type == NIMNetCallMediaTypeAudio? @"音频连接" : @"视频连接";
    [_button setTitle:buttonTitle forState:UIControlStateNormal];
    _button.hidden = !connector.isSelected;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _button.ntesSize = CGSizeMake(self.ntesWidth, 21);
    _button.ntesBottom = self.ntesHeight;
    
    CGFloat spacing = 2.f;
    self.nickLabel.ntesTop = self.avatar.ntesBottom + spacing;
    self.nickLabel.ntesCenterX = self.ntesWidth * .5f;
}

@end
