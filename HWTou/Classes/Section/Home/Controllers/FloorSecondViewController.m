//
//  FloorSecondViewController.m
//  HWTou
//
//  Created by 彭鹏 on 2017/3/25.
//  Copyright © 2017年 LieMi. All rights reserved.
//

#import "FloorSecondViewController.h"
#import "FloorSecondView.h"
#import "PublicHeader.h"
#import "ComFloorDM.h"

@interface FloorSecondViewController ()

@property (nonatomic, strong) FloorSecondView *vFloor;

@end

@implementation FloorSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    self.title = self.floor.title;
    self.vFloor = [[FloorSecondView alloc] init];
    [self.view addSubview:self.vFloor];
    [self.vFloor makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.vFloor.floor = self.floor;
}
@end
