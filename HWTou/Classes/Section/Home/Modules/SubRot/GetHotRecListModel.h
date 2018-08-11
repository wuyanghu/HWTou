//
//  GetHotRecListModel.h
//  HWTou
//
//  Created by robinson on 2017/12/11.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseModel.h"
#import "GuessULikeModel.h"

@interface GetHotRecListModel : BaseModel
@property (nonatomic,assign) NSInteger recId;//推荐ID
@property (nonatomic,copy) NSString * title;//推荐标题
@property (nonatomic,assign) NSInteger flag;//热门推荐类型：1：广播，2：话题，3：聊吧
@property (nonatomic,assign) NSInteger layoutType;//排列格式:1:横排,2:竖排
@property (nonatomic,assign) NSInteger rank;//排序
@property (nonatomic,assign) NSInteger recNum;//
@property (nonatomic,strong) NSMutableArray <GuessULikeModel *>* rtcDetailArr;
@end
