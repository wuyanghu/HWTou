//
//  HomeSubCategoryController.m
//  HWTou
//
//  Created by Reyna on 2017/11/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeSubCategoryController.h"
#import "PublicHeader.h"
#import "RotRequest.h"
#import "ChatClassesViewModel.h"
#import "OneCollectionViewCell.h"
#import "HomeSubCategoryListViewController.h"
#import "BaseCollectionReusableView.h"
#import "SubCategateCollectionReusableView.h"
#import "HomeSubCategoryDetailViewController.h"
#import "AnswerLsCollectionViewCell.h"
#import "AnswerlrViewController.h"
#import "AnswerLsRequest.h"
#import "AnswerlrViewModel.h"
#import "AnswerlrCountDownViewController.h"

@interface HomeSubCategoryController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,AnswerLsCollectionViewCellDelegate>
@property (nonatomic,strong) ChatClassesViewModel * viewModel;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic,strong) AnswerlrViewModel * answerlrViewModel;
@end

@implementation HomeSubCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self requestGetChatClasses:YES];
    [self getSpecList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [self.answerlrViewModel stopTime];
    [self.answerlrViewModel destroyVar];
}

#pragma mark - 网络请求
- (void)requestGetChatClasses:(BOOL)isRefresh{
    [RotRequest getChatClasses:[BaseParam new] Success:^(ArrayResponse *response) {
        [self.viewModel bindWithChatClassesModel:response.data];
        [self.collectionView reloadData];
        if (!isRefresh) {
            [self.collectionView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)getSpecList{
    WeakObj(self);
    GetActivityParam * activityParam = [GetActivityParam new];
    activityParam.specId = 0;
    [AnswerLsRequest getSpecList:activityParam Success:^(AnswerLsArray *response) {
        if (response.status == 200) {
            [selfWeak.answerlrViewModel bindGetSpecList:response.data];
            [self.collectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - buttonAction
- (void)buttonAction:(GetSpecListModel *)specListModel{
    self.answerlrViewModel.selectSpecModel = specListModel;
    [Navigation getServeDate:specListModel.specId from:self isBanner:NO];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.viewModel.chatClassesModelArr.count+1+1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section<self.viewModel.chatClassesModelArr.count) {
        return 1;
    }else if (section == [self.viewModel getSection]){
        return self.viewModel.otherChatClassSecsArr.count;
    }else{
        return 1;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section<self.viewModel.chatClassesModelArr.count) {
        ChatClassesModel * classModel = self.viewModel.chatClassesModelArr[indexPath.section];
        OneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[OneCollectionViewCell cellIdentity] forIndexPath:indexPath];
        [cell setClassModel:classModel];
        
        cell.actionBlock = ^(ChatClassSecsModel * secsModel){
            if (secsModel.classIdSec != -1) {
                HomeSubCategoryListViewController * listVC = [[HomeSubCategoryListViewController alloc] init];
                listVC.classModel = classModel;
                listVC.secsModel = secsModel;
                listVC.chatScrollStyle = YES;
                [self.navigationController pushViewController:listVC animated:YES];
            }else{
                
                [self.viewModel showArrowData:classModel];
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
            }
            
        };
        return cell;
    }else if(indexPath.section == [self.viewModel getSection]){
        ChatClassesModel *  chatSecsModel = self.viewModel.otherChatClassSecsArr[indexPath.row];
        OneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[OneCollectionViewCell otherCellIdentity] forIndexPath:indexPath];
        [cell setOtherClassModel:chatSecsModel];
        return cell;
    }else{
        AnswerLsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AnswerLsCollectionViewCell cellIdentity] forIndexPath:indexPath];
        cell.cellDeleagte = self;
        [cell setDataArray:self.answerlrViewModel.specListArr];
        return cell;
    }
    
}

// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        BaseCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[BaseCollectionReusableView cellIdentity] forIndexPath:indexPath];
        header.hidden = YES;
        reusableView = header;
        
        if (indexPath.section > [self.viewModel getSection]) {
            SubCategateCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[SubCategateCollectionReusableView cellIdentity] forIndexPath:indexPath];
            header.titleLabel.text = @"聊吧答题";
            reusableView = header;
        }
//        else{
//            BaseCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[BaseCollectionReusableView cellIdentity] forIndexPath:indexPath];
//            reusableView = header;
//        }
    }
    if (kind == UICollectionElementKindSectionFooter){
//        if (indexPath.section == 0 || indexPath.section == 1) {
//            TopicFooterCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify1 forIndexPath:indexPath];
//            reusableView = footerview;
//        }else{
//            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewIdentify forIndexPath:indexPath];
//        }
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<self.viewModel.chatClassesModelArr.count) {
        if (indexPath.row == 0) {
            
            ChatClassesModel * classModel = self.viewModel.chatClassesModelArr[indexPath.section];
            HomeSubCategoryListViewController * listVC = [[HomeSubCategoryListViewController alloc] init];
            listVC.classModel = classModel;
            listVC.secsModel = nil;
            if (classModel.chatClassSecsArr.count == 0) {
                listVC.chatScrollStyle = NO;
            }else{
                listVC.chatScrollStyle = YES;
            }
            [self.navigationController pushViewController:listVC animated:YES];
            
        }
    }else if(indexPath.section == [self.viewModel getSection]){
        ChatClassesModel * classModel = self.viewModel.otherChatClassSecsArr[indexPath.row];
        HomeSubCategoryListViewController * listVC = [[HomeSubCategoryListViewController alloc] init];
        listVC.classModel = classModel;
        listVC.secsModel = nil;
        listVC.chatScrollStyle = NO;
        [self.navigationController pushViewController:listVC animated:YES];
    }else{
        
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

//每个item之间的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//每个item之间的纵向的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

// 设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

//设置每个单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<self.viewModel.chatClassesModelArr.count) {
        return [self.viewModel calcuateCellSize:indexPath];
    }else if(indexPath.section == [self.viewModel getSection]){
        if (indexPath.row == 0) {
            return CGSizeMake(90, 95);
        }
        return CGSizeMake((kMainScreenWidth-15)/4, 95);
    }else{
        return CGSizeMake(kMainScreenWidth, 105+20);
    }
    
}
//头部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section > [self.viewModel getSection]) {
        return CGSizeMake(kMainScreenWidth, 50);
    }
    return CGSizeMake(kMainScreenWidth, 10);
}

//尾部view高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

#pragma mark - getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[BaseCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[BaseCollectionReusableView cellIdentity]];
        [_collectionView registerClass:[SubCategateCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[SubCategateCollectionReusableView cellIdentity]];
        [_collectionView registerNib:[UINib nibWithNibName:@"OneCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[OneCollectionViewCell cellIdentity]];
        [_collectionView registerNib:[UINib nibWithNibName:@"OneCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[OneCollectionViewCell otherCellIdentity]];
        [_collectionView registerNib:[UINib nibWithNibName:@"AnswerLsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[AnswerLsCollectionViewCell cellIdentity]];
        
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestGetChatClasses:NO];
            [self getSpecList];
        }];
        
    }
    return _collectionView;
}

- (ChatClassesViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[ChatClassesViewModel alloc] init];
    }
    return _viewModel;
}

- (AnswerlrViewModel *)answerlrViewModel{
    if (!_answerlrViewModel) {
        _answerlrViewModel = [AnswerlrViewModel sharedInstance];
    }
    return _answerlrViewModel;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
