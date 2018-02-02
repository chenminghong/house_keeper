//
//  HomeViewController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "HomeViewController.h"

#import "LoginViewController.h"
#import "PaomaLabel.h"
#import "WQLPaoMaView.h"
#import "HomeTableCell.h"
#import "HomePageModel.h"
#import "SGScanningQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "AdaptiveCodeController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *bannerView; //顶部banner
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *numberButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.userIconBtn.layer.masksToBounds = YES;
    self.userIconBtn.layer.cornerRadius = (kScreenWidth * 6) / 32 / 2.0;
    self.userIconBtn.layer.borderColor = UIColorFromRGB(0xfae4b2).CGColor;
    self.userIconBtn.layer.borderWidth = 2.0;
    
    self.userNameLabel.textColor = UIColorFromRGB(0xffffff);
    self.userNumberLabel.textColor = UIColorFromRGB(0xffffff);
    
    self.bannerView.backgroundColor = TOP_NAVIBAR_COLOR;
    
    self.scanButton.layer.cornerRadius = 10;
    self.numberButton.layer.cornerRadius = 10;
    self.scanButton.backgroundColor = UIColorFromRGB(0x444756);
    self.numberButton.backgroundColor = UIColorFromRGB(0x00a7eb);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if (!self.navigationController.isNavigationBarHidden) {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }
    self.userNameLabel.text = [LoginModel shareLoginModel].account;
    self.userNumberLabel.text = [LoginModel shareLoginModel].name;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.viewControllers.count >= 2) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark -- LazyLoading



/**
 调用接口返回扫描一维码结果

 @param urlStr 接口名称
 @param paraDict 需要传递的参数
 */
- (void)networkWithUrlStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict {
//    [NetworkHelper POST:urlStr parameters:paraDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSString *msg = responseObject[@"remark"];
//        [ProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
//    } failure:^(NSError *error) {
//        [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
//    }];
    MBProgressHUD *hud = [ProgressHUD bwm_showTitle:kBWMMBProgressHUDMsgLoading toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    [[NetworkHelper shareClient] POST:urlStr parameters:paraDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString *msg = responseDict[@"remark"];
        [ProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }];
}

#pragma mark -- ButtonAction

/**
 扫描二维码按钮点击事件

 @param sender 扫描按钮
 */
- (IBAction)scanCodeAction:(UIButton *)sender {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        __weak typeof(self) weakself = self;
        SGScanningQRCodeVC *codeVC = [SGScanningQRCodeVC getSgscanningQRCodeVCWithResultBlock:^(NSString *scanResult) {
            //扫描结束回调
            NSData *jsonData = [[NSData alloc] initWithBase64EncodedString:scanResult options:0];
            if (jsonData) {
                NSError *error = nil;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
                if (!error) {
                    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
                    [paraDict setObject:[LoginModel shareLoginModel].code forKey:@"sourceCode"];
                    [paraDict setObject:QRCODE_SCAN_API forKey:OPERATION_KEY];
                    [NetworkHelper POST:PAIREACH_NETWORK_URL parameters:paraDict hudTarget:self.view progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                        if (!error) {
                            MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:@"扫描成功！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
                            hud.labelFont = [UIFont systemFontOfSize:36.0];
                            hud.cornerRadius = 0.0;
                            hud.minSize = [UIScreen mainScreen].bounds.size;
                        }
                    }];
                }
            } else {
                MBProgressHUD *hud = [MBProgressHUD bwm_showTitle:@"扫描参数错误！" toView:[UIApplication sharedApplication].keyWindow hideAfter:HUD_HIDE_TIMEINTERVAL];
                hud.labelFont = [UIFont systemFontOfSize:36.0];
                hud.cornerRadius = 0.0;
                hud.minSize = [UIScreen mainScreen].bounds.size;
            }
        }];
        NavigationController *naviNC = [[NavigationController alloc] initWithRootViewController:codeVC];
        codeVC.navigationItem.leftBarButtonItem = [NavigationController getNavigationBackItemWithTarget:codeVC SEL:@selector(dismissModalViewControllerAnimated:)];
        [weakself presentViewController:naviNC animated:YES completion:nil];
    } else {
        [MBProgressHUD bwm_showTitle:@"⚠️ 警告:未检测到您的摄像头, 请在真机上测试" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL / 2.0];
    }
}

/**
 自提运单响应事件

 @param sender 点击的按钮
 */
- (IBAction)selfGetNumberAction:(UIButton *)sender {
    AdaptiveCodeController *adaptiveVC = [AdaptiveCodeController new];
    [self.navigationController pushViewController:adaptiveVC animated:YES];
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
