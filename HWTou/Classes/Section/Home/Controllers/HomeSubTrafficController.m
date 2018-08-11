//
//  HomeSubTrafficController.m
//  HWTou
//
//  Created by Reyna on 2017/11/21.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "HomeSubTrafficController.h"

@interface HomeSubTrafficController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation HomeSubTrafficController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestDataSource];
}

#pragma mark - HTTPRequest
/**
 *  请求数据
 */
- (void)requestDataSource {
//    [API requestAnchorData:^(id response, NSString *message, BOOL success) {
//        if(success) {
//            self.model = [XMLYFindAnchorModel xr_modelWithJSON:response];
//            [self.model createDataSource];
//            [self.collectionView reloadData];
//        }
//    }];
}

#pragma mark - UICollectionViewDelegate&DataSource
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return self.model.dataSource.count;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    XMLYAnchorSectionModel *model = self.model.dataSource[section];
//    NSInteger count = model.list.count;
//    return count - count % 3; //保证每一行是3的倍数
//}
//
////item size 210 x 320
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    XMLYAnchorSectionModel *model = self.model.dataSource[indexPath.section];
//    if(model.displayStyle == 2) {
//        return CGSizeMake(kScreenWidth, 90);
//    }
//
//    CGFloat width = kScreenWidth / 3.0f;
//    CGFloat height = 32.0 * width / 21.0;
//    return CGSizeMake(width, height);
//}
//
////footer size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake(kScreenWidth, 10);
//}
//
////header size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(kScreenWidth, 40);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//
////cell
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    XMLYAnchorSectionModel *model = self.model.dataSource[indexPath.section];
//    XMLYAnchorCellModel *cellModel = model.list[indexPath.row];
//    if(model.displayStyle == 2) {
//        XMLYAnchorSignerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMLYAnchorSignerCell" forIndexPath:indexPath];
//        cell.model = cellModel;
//        return cell;
//    }
//    else {
//        XMLYAnchorNormalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMLYAnchorNormalCell" forIndexPath:indexPath];
//        cell.model = cellModel;
//        return cell;
//    }
//}
//
////footer header
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if([kind isEqualToString:kSectionHeader] ) {
//        XMLYAnchorSectionModel *model = self.model.dataSource[indexPath.section];
//        XMLYAnchorHeaderView *header = [XMLYAnchorHeaderView anchorHeaderView:collectionView atIndexPath:indexPath];
//        header.model = model;
//        return header;
//    } else if([kind isEqualToString:kSectionFooter]){
//        XMLYAnchorFooterView *footer = [XMLYAnchorFooterView anchorFooterView:collectionView atIndexPath:indexPath];
//        return footer;
//    }
//    return nil;
//}

#pragma mark - getter

//- (UICollectionView *)collectionView {
//    if(!_collectionView) {
//        CGRect frame = self.view.frame;
//        XMLYAnchorFlowLayout *layout = [[XMLYAnchorFlowLayout alloc] init];
//        layout.minimumLineSpacing = 0;
//        layout.minimumInteritemSpacing = 0;
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        UICollectionView *col = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
//        [col registerNib:[UINib nibWithNibName:@"XMLYAnchorSignerCell" bundle:nil] forCellWithReuseIdentifier:@"XMLYAnchorSignerCell"];
//        [col registerNib:[UINib nibWithNibName:@"XMLYAnchorNormalCell" bundle:nil] forCellWithReuseIdentifier:@"XMLYAnchorNormalCell"];
//        col.delegate = self;
//        col.dataSource = self;
//        col.backgroundColor = Hex(0xf0f0f0);
//        _collectionView = col;
//        [self.view addSubview:col];
//    }
//    return _collectionView;
//}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
