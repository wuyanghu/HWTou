//
//  ManageAddressViewController.h
//  HWTou
//
//  Created by 赤 那 on 2017/3/28.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "BaseViewController.h"

#import "AddressGoodsDM.h"
@class AddressGoodsDM;

typedef void(^AddressSelectedBlock)(AddressGoodsDM *address);
typedef void(^AddressModifyBlock)(AddressGoodsDM *address);

@interface ManageAddressViewController : BaseViewController

- (void)setEditAddressDataSource:(AddressGoodsDM *)model;

- (void)areaSelectionComplete:(NSDictionary *)dic;

@property (nonatomic, copy) AddressSelectedBlock blockAddress;
@property (nonatomic, copy) AddressModifyBlock modifyAddress;

@end
