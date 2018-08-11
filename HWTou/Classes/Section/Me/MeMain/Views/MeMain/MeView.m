//
//  MeView.m
//  HWTou
//
//  Created by 赤 那 on 2017/3/23.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "MeView.h"
#import "PublicHeader.h"
#import "PersonalInfoReq.h"
#import "MeFuncColViewCell.h"
#import "PersonHomeReq.h"
#import "MeHeaderReusableView.h"

#define kFooterViewIdentify @"kFooterViewIdentify"

@interface MeView ()<UICollectionViewDataSource,UICollectionViewDelegate,MeViewProtocol>

@property (nonatomic, strong) UICollectionView *m_FuncColView;
@property (nonatomic, strong) NSArray *m_FuncDataSourceArray;

@end

@implementation MeView
@synthesize m_Delegate;
@synthesize m_FuncDataSourceArray;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        [self dataInitialization];
        [self setBackgroundColor:UIColorFromHex(ME_BG_COLOR)];
        
        [self addSubview:self.m_FuncColView];
        [self.m_FuncColView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return self;
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return m_FuncDataSourceArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return [m_FuncDataSourceArray[section] count];
}
//头部view高度
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return CGSizeMake(kMainScreenWidth, 220);
    }else{
        return CGSizeMake(kMainScreenWidth, 10);
    }
    return CGSizeZero;
}

//尾部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeZero;
}

// 同一行的 cell 的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

// 上下行 cell 的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MeFuncColViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMeFuncColCellId
                                                                        forIndexPath:indexPath];
    MeFuncModel *model = m_FuncDataSourceArray[indexPath.section][indexPath.row];
    [cell setPackageCellUpDataSource:model cellForRowAtIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            MeHeaderReusableView * collectViewHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[MeHeaderReusableView cellIdentity] forIndexPath:indexPath];
            collectViewHeader.m_Delegate = self;
            [collectViewHeader setPersonHomeModel:_personHomeModel];
            reusableView = collectViewHeader;
        }else{
            MeHeaderBgView * headerBgView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[MeHeaderBgView cellIdentity] forIndexPath:indexPath];
            reusableView = headerBgView;
        }
    }
    if (kind == UICollectionElementKindSectionFooter){
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify forIndexPath:indexPath];
    }
    return reusableView;
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onFunctionalResponse:withPersonalInfo:)]) {
        MeFuncModel *model = m_FuncDataSourceArray[indexPath.section][indexPath.row];
        [m_Delegate onFunctionalResponse:model.m_FuncType withPersonalInfo:_personHomeModel];
    }
    
}

#pragma mark - 下拉刷新数据
- (void)loadNewData{
    
    // 马上进入刷新状态
    [self.m_FuncColView.mj_header beginRefreshing];
    [self obtainPersonalInfo];
    
}

#pragma mark - Public Functions
- (void)dataInitialization{
    
    if (IsNilOrNull(m_FuncDataSourceArray)) {
        
        MeFuncModel *redPack = [[MeFuncModel alloc] init];
        [redPack setM_Title:@"我的钱包"];
        [redPack setM_IcoName:@"money"];
        [redPack setM_FuncType:FuncType_RedPacket];
        
//        MeFuncModel *collectionModel = [[MeFuncModel alloc] init];
//        [collectionModel setM_Title:@"我的收藏"];
//        [collectionModel setM_IcoName:@"shoucang"];
//        [collectionModel setM_FuncType:FuncType_MyCollection];
        
        MeFuncModel * investFriendFeedbackModel = [[MeFuncModel alloc] init];
        [investFriendFeedbackModel setM_Title:@"邀请好友"];
        [investFriendFeedbackModel setM_IcoName:@"friend"];
        [investFriendFeedbackModel setM_FuncType:FuncType_InvestFriend];
        
        MeFuncModel * orderModel = [[MeFuncModel alloc] init];
        [orderModel setM_Title:@"我的订单"];
        [orderModel setM_IcoName:@"order"];
        [orderModel setM_FuncType:FuncType_order];
        
        MeFuncModel * paimaiModel = [[MeFuncModel alloc] init];
        [paimaiModel setM_Title:@"我的拍卖"];
        [paimaiModel setM_IcoName:@"paimai"];
        [paimaiModel setM_FuncType:FuncType_paimai];
        
        MeFuncModel *customerFeedbackModel = [[MeFuncModel alloc] init];
        [customerFeedbackModel setM_Title:@"客服与反馈"];
        [customerFeedbackModel setM_IcoName:@"kefu"];
        [customerFeedbackModel setM_FuncType:FuncType_CustomerAndFeedback];
        
        MeFuncModel *personalSetModel = [[MeFuncModel alloc] init];
        [personalSetModel setM_Title:@"设置"];
        [personalSetModel setM_IcoName:@"setting"];
        [personalSetModel setM_FuncType:FuncType_PersonalSetUp];
        
        MeFuncModel *ggSetModel = [[MeFuncModel alloc] init];
        [ggSetModel setM_Title:@"发耶绿色公约"];
        [ggSetModel setM_IcoName:@"dkw_gg"];
        [ggSetModel setM_FuncType:FuncType_GG];
        
        MeFuncModel *userManageModel = [[MeFuncModel alloc] init];
        [userManageModel setM_Title:@"用户管理手册"];
        [userManageModel setM_IcoName:@"shouce"];
        [userManageModel setM_FuncType:FuncType_UserManage];
        
        m_FuncDataSourceArray = @[@[redPack],@[investFriendFeedbackModel,orderModel,paimaiModel,customerFeedbackModel,personalSetModel,ggSetModel,userManageModel]];
        
    }
    
}

#pragma mark - UITapGestureRecognizer Handler
- (void)tapGestureFloor:(UITapGestureRecognizer *)tapGesture{
    if (m_Delegate && [m_Delegate respondsToSelector:@selector(onPersonalInfo)]) {
        [m_Delegate onPersonalInfo];
    }
}

- (void)buttonSelected:(UIButton *)button{
    [m_Delegate buttonSelected:button];
}

#pragma mark - NetworkRequest Manager

- (void)obtainPersonalInfo{
    
    UserInfoParam * homeParam = [UserInfoParam new];
    homeParam.uid = 0;
    //个人资料
    [PersonHomeRequest getUserInfo:homeParam Success:^(PersonHomeResponse *response) {
        [HUDProgressTool dismiss];
        if (response.status == 200) {
            _personHomeModel = response.data;
            [[[AccountManager shared] account] setNickName:_personHomeModel.nickname];
            [self.m_FuncColView reloadData];
        }else{
            [HUDProgressTool showErrorWithText:response.msg];
        }
        [self.m_FuncColView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [HUDProgressTool showErrorWithText:ReqErrCode_Custom_ErrorInfo];
        [self.m_FuncColView.mj_header endRefreshing];
    }];
}

#pragma mark - getter
- (UICollectionView *)m_FuncColView{
    if (!_m_FuncColView) {
        CGFloat itemWidth = kMainScreenWidth;
        CGFloat itemHeight = 44;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        [layout setMinimumLineSpacing:0];
        [layout setMinimumInteritemSpacing:0];
        [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [layout setItemSize:CGSizeMake(itemWidth, itemHeight)];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                       collectionViewLayout:layout];
        
        [colView setDelegate:self];
        [colView setDataSource:self];
        [colView setAlwaysBounceVertical:NO];
        [colView setBackgroundColor:[UIColor clearColor]];
        
#ifdef __IPHONE_11_0
        if ([colView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            colView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        [colView registerClass:[MeFuncColViewCell class] forCellWithReuseIdentifier:kMeFuncColCellId];
        [colView registerClass:[MeHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[MeHeaderReusableView cellIdentity]];
        [colView registerClass:[MeHeaderBgView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[MeHeaderBgView cellIdentity]];
        [colView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify];

        
        // 下拉刷新
        WeakObj(self);
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [selfWeak loadNewData];
        }];
        
        [header.lastUpdatedTimeLabel setHidden:YES];
        colView.mj_header = header;
        _m_FuncColView = colView;
    }
    return _m_FuncColView;
}

@end


