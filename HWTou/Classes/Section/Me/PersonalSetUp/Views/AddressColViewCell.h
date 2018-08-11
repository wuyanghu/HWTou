//
//  AddressColViewCell.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressGoodsDM.h"

#define kAddressColViewCellId       (@"AddressColCellId")

@protocol AddressColViewDelegate <NSObject>

- (void)onDefAddr:(AddressGoodsDM *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)onEditor:(AddressGoodsDM *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)onDelete:(AddressGoodsDM *)model cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface AddressColViewCell : UICollectionViewCell

@property (nonatomic, strong) AddressGoodsDM *m_Model;

@property (nonatomic, weak) id<AddressColViewDelegate> m_Delegate;

- (void)setAddressColCellUpDataSource:(AddressGoodsDM *)model
                cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)setDefaultAddress:(BOOL)isChoose;

@end
