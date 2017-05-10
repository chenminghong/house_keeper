//
//  AdaptiveCodeController.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/9.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "AdaptiveCodeController.h"

#import "PlateNumbersController.h"
#import "DriverModel.h"

@interface AdaptiveCodeController ()
@property (weak, nonatomic) IBOutlet UITextField *orderCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation AdaptiveCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"自提运单";
    
}

#pragma mark -- 按钮点击事件


/**
 下一步按钮点击事件

 @param sender 下一步按钮
 */
- (IBAction)nextButtonAction:(UIButton *)sender {
    if ([self.orderCodeTF.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        [MBProgressHUD bwm_showTitle:@"请输入运单号！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL / 2.0];
        return;
    }
    NSDictionary *paraDict = @{@"userName":[LoginModel shareLoginModel].tel.length>0? [LoginModel shareLoginModel].tel:@"", @"orderCode":self.orderCodeTF.text, @"lat":@"0.0", @"lng":@"0.0"};
    
    [DriverModel getDataWithParameters:paraDict endBlock:^(id model, NSError *error) {
        if (model) {
            PlateNumbersController *plateNumbersVC = [PlateNumbersController new];
            plateNumbersVC.orderCode = self.orderCodeTF.text;
            plateNumbersVC.driverModel = model;
            [self.navigationController pushViewController:plateNumbersVC animated:YES];
        } else {
            [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
    }];
}

//单击结束编辑
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view == self.view) {
        [self.view endEditing:YES];
    }
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
