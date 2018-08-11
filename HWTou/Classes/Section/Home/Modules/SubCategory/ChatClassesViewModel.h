//
//  ChatClassesViewModel.h
//  HWTou
//
//  Created by robinson on 2018/1/3.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseViewModel.h"
#import "ChatClassesModel.h"

@interface ChatClassesViewModel : BaseViewModel
@property (nonatomic,strong) NSMutableArray<ChatClassesModel *> * chatClassesModelArr;
@property (nonatomic,strong) NSMutableArray<ChatClassesModel *> * otherChatClassSecsArr;
- (void)bindWithChatClassesModel:(NSArray *)array;
- (void)showArrowData:(ChatClassesModel * )chatModel;
- (CGSize)calcuateCellSize:(NSIndexPath *)indexPath;//计算cell高度
- (NSInteger)getSection;
@end
