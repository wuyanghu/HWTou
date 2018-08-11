//
//  NoticeViewController.m
//  HWTou
//
//  Created by robinson on 2018/3/27.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "NoticeViewController.h"
#import "ComCarouselView.h"
#import "PublicHeader.h"

@interface NoticeViewController ()
@property (weak, nonatomic) IBOutlet UIView *scrollbgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) ComCarouselImageView *scrollbgView2;
@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = _getChatInfoModel.chatTitle;
    self.contentLabel.text = _getChatInfoModel.chatContent;
    
    NSArray * bmgs = [_getChatInfoModel.bmgUrls componentsSeparatedByString:@","];
    
    self.scrollbgView2 = [[ComCarouselImageView alloc] init];
    [self.scrollbgView2 setImageURLStringsGroup:bmgs];
    [self.view addSubview:self.scrollbgView2];
    
    [self.scrollbgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollbgView);
    }];
//    self.scrollbgView2.frame = self.scrollbgView.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)popViewAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setGetChatInfoModel:(GetChatInfoModel *)getChatInfoModel{
    _getChatInfoModel = getChatInfoModel;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
