//
//  NTESLiveChatView.m
//  NIMLiveDemo
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveChatView.h"
#import "UIView+NTES.h"
#import "NTESMessageModel.h"
#import "NTESLiveChatTableViewCell.h"
#import "NTESLiveChatSystemTableViewCell.h"
#import "PublicHeader.h"

@interface NTESLiveChatView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,NTESLiveChatTextCellDelegate>

@property (nonatomic,strong) NSMutableArray<NTESMessageModel *> *messages;

@property (nonatomic,strong) NSMutableArray *pendingMessages;   //缓存的插入消息,聊天室需要在另外个线程计算高度,减少UI刷新

@end

@implementation NTESLiveChatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _messages = [[NSMutableArray alloc] init];
        _pendingMessages = [[NSMutableArray alloc] init];
        [self addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        tap.delegate=self;
        [self addGestureRecognizer:tap];

    }
    return self;
}

-(void)doTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self.superview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTapChatView:)]) {
        [self.delegate onTapChatView:point];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;//关闭手势
    }
    return YES;
}

- (void)addMessages:(NSArray<NIMMessage *> *)messages
{
    if (messages.count) {
        [self caculateHeight:messages];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTESMessageModel *model = self.messages[indexPath.row];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NTESLiveChatSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NTESLiveChatSystemTableViewCell cellReuseIdentifierInfo]];
        NTESMessageModel *model = self.messages[indexPath.row];
        [cell setContent:model.message.text];
        return cell;
        
    }else{
        NTESLiveChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NTESLiveChatTableViewCell cellReuseIdentifierInfo]];
        cell.cellDelegate = self;
        NTESMessageModel *model = self.messages[indexPath.row];
        [cell refresh:model];
        return cell;
    }
    
}

#pragma mark - NTESLiveChatTextCellDelegate

- (void)longGesturePress:(NTESMessageModel *)model{
    [self.delegate longGesturePress:model];
}

- (void)headerAction:(NTESMessageModel *)model{
    [self.delegate headerAction:model];
}

#pragma mark - Get
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"NTESLiveChatTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[NTESLiveChatTableViewCell cellReuseIdentifierInfo]];
        [_tableView registerNib:[UINib nibWithNibName:@"NTESLiveChatSystemTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[NTESLiveChatSystemTableViewCell cellReuseIdentifierInfo]];
        
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
//        _tableView.contentInset = UIEdgeInsetsMake(self.ntesHeight, 0, 0, 0);
    }
    return _tableView;
}


#pragma mark - Private

- (void)caculateHeight:(NSArray<NIMMessage *> *)messages
{
    dispatch_async(NTESMessageDataPrepareQueue2(), ^{
        //后台线程处理宽度计算，处理完之后同步抛到主线程插入
        BOOL noPendingMessage = self.pendingMessages.count == 0;
        [self.pendingMessages addObjectsFromArray:messages];
        if (noPendingMessage)
        {
            [self processPendingMessages];
        }
    });
}

- (void)processPendingMessages
{
    __weak typeof(self) weakSelf = self;
    NSUInteger pendingMessageCount = self.pendingMessages.count;
    if (!weakSelf || pendingMessageCount== 0) {
        return;
    }
    
    if (weakSelf.tableView.isDecelerating || weakSelf.tableView.isDragging)
    {
        //滑动的时候为保证流畅，暂停插入
        NSTimeInterval delay = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), NTESMessageDataPrepareQueue2(), ^{
            [weakSelf processPendingMessages];
        });
        return;
    }
    
    //获取一定量的消息计算高度，并扔回到主线程
    static NSInteger NTESMaxInsert = 2;
    NSArray *insert = nil;
    NSRange range;
    if (pendingMessageCount > NTESMaxInsert)
    {
        range = NSMakeRange(0, NTESMaxInsert);
    }
    else
    {
        range = NSMakeRange(0, pendingMessageCount);
    }
    insert = [self.pendingMessages subarrayWithRange:range];
    [self.pendingMessages removeObjectsInRange:range];
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (NIMMessage *message in insert)
    {
        NTESMessageModel *model = [[NTESMessageModel alloc] init];
        model.message = message;
        [model caculate:self.ntesWidth];
        [models addObject:model];
    }
    
    NSUInteger leftPendingMessageCount = self.pendingMessages.count;
    dispatch_sync(dispatch_get_main_queue(), ^{
        [weakSelf addModels:models];
    });
    
    if (leftPendingMessageCount)
    {
        NSTimeInterval delay = 0.1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), NTESMessageDataPrepareQueue2(), ^{
            [weakSelf processPendingMessages];
        });
    }
}

- (void)addModels:(NSArray<NTESMessageModel *> *)models
{
    NSInteger count = self.messages.count;
    [self.messages addObjectsFromArray:models];
    
    NSMutableArray *insert = [[NSMutableArray alloc] init];
    for (NSInteger index = count; index < count+models.count; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [insert addObject:indexPath];
    }
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self.tableView layoutIfNeeded];
    
    
//    [self changeInsets:models];
    [self scrollToBottom];
}

- (void)changeInsets:(NSArray<NTESMessageModel *> *)newModels
{
    CGFloat height = 0;
    for (NTESMessageModel *model in newModels) {
        height += model.height;
    }
    UIEdgeInsets insets = self.tableView.contentInset;
    CGFloat contentHeight = self.tableView.contentSize.height - insets.top;
    contentHeight += height;
    CGFloat top = contentHeight > self.tableView.ntesHeight? 0 : self.tableView.ntesHeight - contentHeight;
    insets.top = top;
//    self.tableView.contentInset = insets;
}

- (void)scrollToBottom
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGFloat offset = self.tableView.contentSize.height - self.tableView.ntesHeight;
//        [self.tableView scrollRectToVisible:CGRectMake(0, offset, self.tableView.ntesWidth, self.tableView.ntesHeight) animated:YES];
        [self scrollTableToBottom];
    });
}

- (void)scrollTableToBottom
{
    CGFloat yOffset = 0; //设置要滚动的位置 0最顶部 CGFLOAT_MAX最底部
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height+35;
    }
    [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
}

static const void * const NTESDispatchMessageDataPrepareSpecificKey = &NTESDispatchMessageDataPrepareSpecificKey;
dispatch_queue_t NTESMessageDataPrepareQueue2()
{
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("nim.live.demo.message.queue", 0);
        dispatch_queue_set_specific(queue, NTESDispatchMessageDataPrepareSpecificKey, (void *)NTESDispatchMessageDataPrepareSpecificKey, NULL);
    });
    return queue;
}


@end


