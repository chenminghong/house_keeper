//
//  PlateNumbersController.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/9.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "PlateNumbersController.h"

#import "CommonPickerView.h"
#import "DriverModel.h"

@interface PlateNumbersController ()

@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UITextField *plateNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation PlateNumbersController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"自提运单";
    
    self.selectedButton.backgroundColor = MAIN_THEME_COLOR;
    self.selectedButton.layer.masksToBounds = YES;
    self.selectedButton.layer.cornerRadius = 5.0;
    self.selectedButton.titleLabel.numberOfLines = 0;
    self.selectedButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.commitButton.backgroundColor = MAIN_THEME_COLOR;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.orderCodeLabel.text = self.orderCode;
    self.plateNumberTF.text = self.driverModel.truckNumber;
    self.phoneNumberTF.text = self.driverModel.driverTel;
    
    self.navigationItem.leftBarButtonItem = [NavigationController getNavigationBackItemWithTarget:self SEL:@selector(backAction)];
}


#pragma mark -- 按钮点击事件

//返回首页
- (void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 选择车牌省份按钮点击事件

 @param sender 选择省份按钮
 */
- (IBAction)selectedButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"plist"];
    NSArray *provincesArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    [CommonPickerView showPickerViewInView:self.view titleList:provincesArr pickBlock:^(NSString *reasonTitle) {
        [self.plateNumberTF becomeFirstResponder];
        self.plateNumberTF.text = reasonTitle;
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
    if (![InputValueCheckUtil checkPhoneNum:self.self.phoneNumberTF.text]) {
        [MBProgressHUD bwm_showTitle:@"输入的手机号格式有误！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL/2.0];
        return;
    }
    NSDictionary *paraDict = @{@"userName":[LoginModel shareLoginModel].name.length>0? [LoginModel shareLoginModel].name:@"", @"mobile":self.phoneNumberTF.text, @"orderCode":self.orderCode, @"carNumber":self.plateNumberTF.text};
    [self networkWithUrlStr:COMMIT_DRIVERINFO_API paraDict:paraDict];
}

/**
 提交司机信息
 
 @param urlStr 接口名称
 @param paraDict 需要传递的参数
 */
- (void)networkWithUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict {
    [NetworkHelper POST:urlStr parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSInteger result = [responseObject[@"result"] integerValue];
        NSString *remark = responseObject[@"remark"];
        MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:remark toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        [hud setCompletionBlock:^() {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    } failure:^(NSError *error) {
        [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }];
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
