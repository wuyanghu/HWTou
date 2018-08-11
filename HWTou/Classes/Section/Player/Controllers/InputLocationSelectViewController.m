//
//  InputLocationSelectViewController.m
//  HWTou
//
//  Created by Reyna on 2018/1/23.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "InputLocationSelectViewController.h"
#import "PublicHeader.h"
#import "LocationNameCell.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface InputLocationSelectViewController () <AMapSearchDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation InputLocationSelectViewController

+ (instancetype)createWithLat:(double)lat lng:(double)lng delegate:(id<InputLocationSelectDelegate>)delegate {
    InputLocationSelectViewController *vc = [[InputLocationSelectViewController alloc] init];
    vc.orderedLat = lat;
    vc.orderedLng = lng;
    vc.delegate = delegate;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self listRequest];
}

- (void)createUI {
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64)];
    navView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:navView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(20, 20, 60, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:SYSTEM_FONT(15)];
    [cancelBtn addTarget:self action:@selector(exitLocationSelectVC) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:cancelBtn];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, kMainScreenWidth - 200, 44)];
    titleLab.text = @"当前位置";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = SYSTEM_FONT(18);
    [navView addSubview:titleLab];
}

- (void)listRequest {

    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:self.orderedLat longitude:self.orderedLng];
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
}

#pragma mark - AmapSearchDelegate

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        //解析response获取地址描述，具体解析见 Demo
    }
    
    NSLog(@"__%@__",response.regeocode.pois);
    
    [self.dataArray removeAllObjects];
    
    for (int i=0; i<response.regeocode.pois.count; i++) {
        
        AMapPOI *poi = [response.regeocode.pois objectAtIndex:i];
        
        [self.dataArray addObject:poi];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}


#pragma mark - TableViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.POINameLab.text = @"不显示位置";
        cell.disLab.text = @"";
        return cell;
    }
    AMapPOI *poi = [self.dataArray objectAtIndex:indexPath.row - 1];
    cell.POINameLab.text = poi.name;

    //保留两位小数，四舍五入
    CGFloat dis = poi.distance/1000.0;
    CGFloat d = round(dis * 100)/100;
    cell.disLab.text = [NSString stringWithFormat:@"%.2fkm",d];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        if (self.delegate) {
            [self.delegate didNotDisplayLocation];
        }
        [self exitLocationSelectVC];
        return;
    }
    AMapPOI *poi = [self.dataArray objectAtIndex:indexPath.row - 1];
    if (self.delegate) {
        [self.delegate didSelectLocation:poi.name];
    }
    [self exitLocationSelectVC];
}

#pragma mark - Sup

- (void)exitLocationSelectVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#ifdef __IPHONE_11_0
        if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        [_tableView registerNib:[UINib nibWithNibName:@"LocationNameCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"locationCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
