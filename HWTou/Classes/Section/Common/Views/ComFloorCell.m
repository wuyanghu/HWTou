//
//  ComFloorCell.m
//  HWTou
//
//  Created by pengpeng on 17/3/22.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "FloorSecondViewController.h"
#import "ComFloorEvent.h"
#import "ComFloorCell.h"
#import "PublicHeader.h"
#import "ComFloorDM.h"

@implementation ComFloorCell

@end

@interface FloorOneCell ()

@property (nonatomic, strong) UIImageView *imgvIcon;

@end

@implementation FloorOneCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.imgvIcon = [[UIImageView alloc] init];
    self.imgvIcon.userInteractionEnabled = YES;
    [self addSubview:self.imgvIcon];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureFloor:)];
    [self.imgvIcon addGestureRecognizer:tapGesture];
    
    [self.imgvIcon makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setFloorData:(NSArray<FloorDataDM *> *)floorData
{
    [super setFloorData:floorData];
    FloorDataDM *fData = [floorData firstObject];
    NSURL *url = [NSURL URLWithString:fData.img_url];
    [self.imgvIcon sd_setImageWithURL:url];
}

- (void)tapGestureFloor:(UITapGestureRecognizer *)tapGesture
{
    FloorDataDM *dmFloor = [self.floorData firstObject];
    if (dmFloor.floorItems.count > 1) {
        FloorSecondViewController *secondVC = [[FloorSecondViewController alloc] init];
        secondVC.floor = dmFloor;
        [self.viewController.navigationController pushViewController:secondVC animated:YES];
    } else {
        [ComFloorEvent handleEventWithFloor:dmFloor.floorItems.firstObject];
    }
}

@end

@interface FloorTwoCell ()

@property (nonatomic, strong) UIImageView *imgvLeft;
@property (nonatomic, strong) UIImageView *imgvRight;

@end

@implementation FloorTwoCell

#define IMGV_TAG_LEFT 1000
#define IMGV_TAG_RIGHT 2000

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.imgvLeft = [[UIImageView alloc] init];
    self.imgvRight = [[UIImageView alloc] init];
    self.imgvLeft.tag = IMGV_TAG_LEFT;
    self.imgvRight.tag = IMGV_TAG_RIGHT;
    self.imgvLeft.userInteractionEnabled = YES;
    self.imgvRight.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapLeft = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureFloor:)];
    UITapGestureRecognizer *tapRight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureFloor:)];
    [self.imgvRight addGestureRecognizer:tapRight];
    [self.imgvLeft addGestureRecognizer:tapLeft];
    
    [self addSubview:self.imgvLeft];
    [self addSubview:self.imgvRight];
    
    [self.imgvLeft makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5).offset(-1.5);
    }];
    
    [self.imgvRight makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(self);
        make.width.equalTo(self.imgvLeft);
    }];
}

- (void)setFloorData:(NSArray<FloorDataDM *> *)floorData
{
    [super setFloorData:floorData];
    [floorData enumerateObjectsUsingBlock:^(FloorDataDM *obj, NSUInteger idx, BOOL *stop) {
        NSURL *url = [NSURL URLWithString:obj.img_url];
        if (obj.sequence == 2) {
            [self.imgvRight sd_setImageWithURL:url];
        } else {
            [self.imgvLeft sd_setImageWithURL:url];
        }
    }];
}

- (void)tapGestureFloor:(UITapGestureRecognizer *)tapGesture
{
    FloorDataDM *dmFloor = nil;
    if (tapGesture.view.tag == IMGV_TAG_LEFT) {
        dmFloor = [self.floorData firstObject];
    } else {
        dmFloor = [self.floorData lastObject];
    }
    if (dmFloor.floorItems.count > 1) {
        FloorSecondViewController *secondVC = [[FloorSecondViewController alloc] init];
        secondVC.floor = dmFloor;
        [self.viewController.navigationController pushViewController:secondVC animated:YES];
    } else {
        [ComFloorEvent handleEventWithFloor:dmFloor.floorItems.firstObject];
    }
    
}

@end
