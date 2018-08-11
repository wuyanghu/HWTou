//
//  TopicAudioSelectView.m
//  HWTou
//
//  Created by Reyna on 2017/12/7.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "TopicAudioSelectView.h"
#import "PublicHeader.h"
#import "UIControl+Event.h"
#import "TopicAudioSelectCell.h"

#define VIEW_HEIGHT 400.f

@interface TopicAudioSelectView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIControl *backImageView;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation TopicAudioSelectView

- (instancetype)init {
    if (self = [super init]) {
  
        [self initMusicItems];
        [self setupSubviews];
    }
    return self;
}

- (void)initMusicItems{
    
    self.items = [NSMutableArray array];
    
    MPMediaQuery *query = [MPMediaQuery songsQuery];

    for (MPMediaItemCollection *conllection in query.collections) {

        for (MPMediaItem *item in conllection.items) {
            [self.items addObject:item];
        }
    }
    
}

- (void)setupSubviews {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, VIEW_HEIGHT)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, kMainScreenWidth - 20, 12)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"声音媒体库";
    titleLab.font = SYSTEM_FONT(12);
    titleLab.textColor = UIColorFromHex(0x646665);
    [bgView addSubview:titleLab];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kMainScreenWidth, VIEW_HEIGHT - 30) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerNib:[UINib nibWithNibName:@"TopicAudioSelectCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"audioCell"];
    [bgView addSubview:tableView];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;
}

#pragma mark - TableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicAudioSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"audioCell" forIndexPath:indexPath];
    
    MPMediaItem *item = [self.items objectAtIndex:indexPath.row];
    
    MPMediaItemArtwork *artwork = [item valueForKey:MPMediaItemPropertyArtwork];
    UIImage *image = [artwork imageWithSize:CGSizeMake(cell.headerIV.bounds.size.width, cell.headerIV.bounds.size.height)];
    
    cell.headerIV.image = image;
    cell.nameLab.text = [item valueForKey:MPMediaItemPropertyTitle];
    cell.typeLab.text = [NSString stringWithFormat:@"格式:%@",[item valueForKey:MPMediaItemPropertyMediaType]];
    cell.sizeLab.text = [NSString stringWithFormat:@"长度:%@",[item valueForKey:MPMediaItemPropertyPlaybackDuration]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MPMediaItem *item = [self.items objectAtIndex:indexPath.row];
    [self dismiss];
    if (self.selectBlock) {
        self.selectBlock(item);
    }
}

#pragma mark - Custom

- (void)show {
    
    UIViewController *topVC = [self appRootViewController];
    
    topVC.view.backgroundColor = [UIColor whiteColor];
    
    self.frame = CGRectMake(0, kMainScreenHeight - VIEW_HEIGHT + kMainScreenHeight, kMainScreenWidth, VIEW_HEIGHT);
    
    [topVC.view addSubview:self];
}

- (void)dismiss {
    
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController {
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview {
    
    CGRect afterFrame = CGRectMake(0, kMainScreenHeight - VIEW_HEIGHT + kMainScreenHeight, kMainScreenWidth, VIEW_HEIGHT);
    
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
        
        [self.backImageView removeFromSuperview];
        self.backImageView = nil;
    }];
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIControl alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        __weak typeof(self) weakSelf = self;
        [self.backImageView addEvent:UIControlEventTouchDown callback:^{
            [weakSelf dismiss];
        }];
    }
    [topVC.view addSubview:self.backImageView];
    
    CGRect afterFrame = CGRectMake(0, kMainScreenHeight - VIEW_HEIGHT, kMainScreenWidth, VIEW_HEIGHT);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
        self.backImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
    
    
    [super willMoveToSuperview:newSuperview];
}

@end
