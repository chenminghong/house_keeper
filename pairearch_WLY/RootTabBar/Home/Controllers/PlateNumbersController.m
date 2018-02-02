//
//  PlateNumbersController.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/9.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "PlateNumbersController.h"

#import "BidPickerView.h"
#import "DriverModel.h"

@interface PlateNumbersController ()

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UITextField *orderCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *plateNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation PlateNumbersController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"自提运单";
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.selectedButton.backgroundColor = [UIColor whiteColor];
    self.selectedButton.layer.cornerRadius = 5.0;
    self.selectedButton.layer.borderWidth = 0.5;
    self.selectedButton.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.commitButton.backgroundColor = MAIN_BUTTON_BGCOLOR;
    self.commitButton.layer.cornerRadius = 5;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    
}

- (void)setOrderCode:(NSString *)orderCode {
    _orderCode = orderCode;
    self.orderCodeTF.text = orderCode;
    NSDictionary *paraDict = @{@"sourceCode":[LoginModel shareLoginModel].code,
                               @"orderCode":orderCode,
                               @"driverTel":@"",
                               OPERATION_KEY:QUERY_ORDER_LIST_API
                               };
    [NetworkHelper GET:PAIREACH_NETWORK_URL parameters:paraDict hudTarget:self.view progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            NSLog(@"查询成功");
        }
    }];
}


#pragma mark -- 按钮点击事件

/**
 选择车牌省份按钮点击事件

 @param sender 选择省份按钮
 */
- (IBAction)selectedButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"plist"];
    NSArray *provincesArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    [BidPickerView showTimeSelectViewWithTitle:@"请选择省份简称" dataArr:provincesArr selectBlock:^(id model) {
        [self.plateNumberTF becomeFirstResponder];
        [self.selectedButton setTitle:model forState:UIControlStateNormal];
    }];
}


/**
 提交按钮点击事件

 @param sender 提交按钮
 */
- (IBAction)commitButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if ([NetworkHelper getNetworkStatus] == NetworkStatusNone) {
        [MBProgressHUD bwm_showTitle:@"网络连接错误，请检查网络！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL/2.0];
    }
    
    if (self.plateNumberTF.text.length == 0 || self.phoneNumberTF.text.length == 0) {
        [MBProgressHUD bwm_showTitle:@"车牌号和手机号不能为空，请重新输入！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        return;
    }
    
    //验证手机号是否正确
//    if (![InputValueCheckUtil checkPhoneNum:self.self.phoneNumberTF.text]) {
//        [MBProgressHUD bwm_showTitle:@"输入的手机号格式有误！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL/2.0];
//        return;
//    }
    
    NSDictionary *paraDict = @{@"sourceCode":[LoginModel shareLoginModel].code,
                               @"driverTel":self.phoneNumberTF.text,
                               @"orderCode":self.orderCode,
                               @"vehicleNumber":self.plateNumberTF.text,
                               OPERATION_KEY:ORDER_INFO_SUBMIT_API
                               };
    [NetworkHelper GET:PAIREACH_NETWORK_URL parameters:paraDict hudTarget:self.view progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:@"操作成功！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
            [hud setCompletionBlock:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    }];
}

/**
 提交司机信息
 
 @param urlStr 接口名称
 @param paraDict 需要传递的参数
 */
- (void)networkWithUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict {
//    [NetworkHelper POST:urlStr parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
////        NSInteger result = [responseObject[@"result"] integerValue];
//        NSString *remark = responseObject[@"remark"];
//        MBProgressHUD *hud = [ProgressHUD bwm_showTitle:remark toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
//        [hud setCompletionBlock:^() {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }];
//    } failure:^(NSError *error) {
//        [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
