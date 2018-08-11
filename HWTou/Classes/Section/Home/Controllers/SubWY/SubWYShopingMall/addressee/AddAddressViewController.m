//
//  AddAddressViewController.m
//  HWTou
//
//  Created by robinson on 2018/4/12.
//  Copyright © 2018年 LieMi. All rights reserved.
//

#import "AddAddressViewController.h"
#import "IQKeyboardManager.h"
#import "ShopMallRequest.h"
#import "UIView+Toast.h"
#import "MOFSPickerManager.h"

@interface AddAddressViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressCityBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressAreaBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *otherTextField;


@property (nonatomic,strong) AddGoodsAddrParam * addGoodsAddrParam;
@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"添加收件人"];
    
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataInit{
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    self.addressBtn.layer.borderColor = UIColorFromRGB(0xC3C3C3).CGColor;
    self.addressBtn.layer.borderWidth = 1;
    
    self.addressCityBtn.layer.borderColor = UIColorFromRGB(0xC3C3C3).CGColor;
    self.addressCityBtn.layer.borderWidth = 1;
    
    self.addressAreaBtn.layer.borderColor = UIColorFromRGB(0xC3C3C3).CGColor;
    self.addressAreaBtn.layer.borderWidth = 1;
    
    
}

#pragma mark - action

- (IBAction)addressAction:(id)sender {
    NSLog(@"弹出城市选择框");
    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:nil cancelTitle:@"取消" commitTitle:@"完成" commitBlock:^(NSString *address, NSString *zipcode) {
        NSArray * addressArr = [address componentsSeparatedByString:@"-"];
        NSString * addressString = @"";
        if (addressArr.count>0) {
            addressString = addressArr[0];
            addressString = [addressString stringByReplacingOccurrencesOfString:@"省" withString:@""];
            addressString = [addressString stringByReplacingOccurrencesOfString:@"市" withString:@""];
            
            [self.addressBtn setTitle:addressString forState:UIControlStateNormal];
        }
        
        if (addressArr.count>1) {
            addressString = addressArr[1];
            addressString = [addressString stringByReplacingOccurrencesOfString:@"市" withString:@""];
            [self.addressCityBtn setTitle:addressString forState:UIControlStateNormal];
        }
        
        if (addressArr.count>2) {
            addressString = addressArr[2];
            addressString = [addressString stringByReplacingOccurrencesOfString:@"区" withString:@""];
            [self.addressAreaBtn setTitle:addressString forState:UIControlStateNormal];
        }
        
        self.addGoodsAddrParam.address = address;
    } cancelBlock:^{
        
    }];
}


- (IBAction)surenewAddAction:(id)sender {
    if (self.nameTextField.editing) {
        [self.nameTextField resignFirstResponder];
    }
    if (self.telTextField.editing) {
        [self.telTextField resignFirstResponder];
    }
    if (self.otherTextField.editing) {
        [self.otherTextField resignFirstResponder];
    }
    
    self.addGoodsAddrParam.addrName = self.nameTextField.text;
    self.addGoodsAddrParam.addrPhone = self.telTextField.text;
    self.addGoodsAddrParam.addressDetail = self.otherTextField.text;
    
    if ([self.addGoodsAddrParam.addrName isEqualToString:@""]) {
        [self.view makeToast:@"收件人姓名不能为空" duration:2.0f position:CSToastPositionCenter];
        return;
    }else if ([self.addGoodsAddrParam.addrPhone isEqualToString:@""]){
        [self.view makeToast:@"收件人手机号不能为空" duration:2.0f position:CSToastPositionCenter];
        return;
    }else if ([self.addGoodsAddrParam.address isEqualToString:@""]){
        [self.view makeToast:@"收件人地区地址不能为空" duration:2.0f position:CSToastPositionCenter];
        return;
    }else if ([self.addGoodsAddrParam.addressDetail isEqualToString:@""]){
        [self.view makeToast:@"收件人详细地址不能为空" duration:2.0f position:CSToastPositionCenter];
        return;
    }
    
    [ShopMallRequest addGoodsAddr:self.addGoodsAddrParam Success:^(AnswerLsDict *response) {
        if (response.status == 200) {
            if (self.delegate) {
                [self.delegate addAddressVCAction];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.view makeToast:response.msg duration:2.0f position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"网络繁忙" duration:2.0f position:CSToastPositionCenter];
    }];
    
}

#pragma mark -  getter
- (AddGoodsAddrParam *)addGoodsAddrParam{
    if (!_addGoodsAddrParam) {
        _addGoodsAddrParam = [AddGoodsAddrParam new];
    }
    return _addGoodsAddrParam;
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
