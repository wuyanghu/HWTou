//
//  AddressManageView.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/26.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddressGoodsDM.h"

@protocol AddressManageViewDelegate <NSObject>

- (void)onEditor:(AddressGoodsDM *)model;
- (void)didSelectItem:(AddressGoodsDM *)model;
- (void)deleteAddress:(AddressGoodsDM *)model;

@end

@interface AddressManageView : UIView

@property (nonatomic, weak) id<AddressManageViewDelegate> m_Delegate;

- (void)accessDataSource;

@end
