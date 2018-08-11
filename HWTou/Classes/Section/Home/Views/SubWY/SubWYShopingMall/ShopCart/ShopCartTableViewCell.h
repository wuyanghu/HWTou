//
//  ShopCartTableViewCell.h
//  HWTou
//
//  Created by robinson on 2018/4/9.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GetShopCartListModel.h"

typedef enum : NSUInteger{
    ShopCartTableViewCellTypeAdd,
    ShopCartTableViewCellTypeDel,
}ShopCartTableViewCellType;

@protocol ShopCartTableViewCellDelegate
- (void)shopCartTableViewCellAction:(GetShopCartListResultModel *)model listModel:(GetShopCartListModel *)listModel type:(ShopCartTableViewCellType)type;
@end

@interface ShopCartTableViewCell : BaseTableViewCell
@property (nonatomic,weak) id<ShopCartTableViewCellDelegate> delegate;
@property (nonatomic,strong) GetShopCartListResultModel * reusltModel;
@property (nonatomic,strong) GetShopCartListModel * listModel;
@end
