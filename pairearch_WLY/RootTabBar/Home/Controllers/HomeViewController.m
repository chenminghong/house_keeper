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

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *userIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *bannerView; //顶部banner
@property (nonatomic, strong) PaomaLabel *noticeContentL;  //通知公告栏
@property (nonatomic, strong) WQLPaoMaView *paoma;  //公告栏；

@property (nonatomic, strong) UILabel *headLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.paoma];
    
    self.userIconBtn.layer.masksToBounds = YES;
    self.userIconBtn.layer.cornerRadius = (kScreenWidth * 6) / 32 / 2.0;
    
    
    self.userNameLabel.textColor = UIColorFromRGB(0x666666);
    self.userNumberLabel.textColor = UIColorFromRGB(0x666666);
    
    self.bannerView.backgroundColor = TOP_BOTTOMBAR_COLOR;
    
    //从后台到前台开始动画
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotificationAction) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.userNameLabel.text = [LoginModel shareLoginModel].name;
    self.userNumberLabel.text = [LoginModel shareLoginModel].tel;
    
    [self.paoma startAnimation];
    
}

//程序活跃的时候调用
- (void)applicationDidBecomeActiveNotificationAction {
    [self paomaViewStartAnimation];
}

//开始跑马灯
- (void)paomaViewStartAnimation {
    if (self.tabBarController.selectedIndex == 0) {
        [self.paoma startAnimation];
    }
}

#pragma mark -- LazyLoading

- (WQLPaoMaView *)paoma {
    if (!_paoma) {
        self.paoma = [[WQLPaoMaView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), self.view.frame.size.width, 40) withTitle:@"Copyright©2017 上海双至供应链管理有限公司"];
        [self.view addSubview:self.paoma];
        [self.paoma mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView.mas_bottom);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(40);
        }];
        self.paoma.backgroundColor = MAIN_THEME_COLOR;
    }
    return _paoma;
}

- (UILabel *)headLabel {
    if (!_headLabel) {
        self.headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60.0)];
        self.headLabel.textAlignment = NSTextAlignmentCenter;
        self.headLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        self.headLabel.textColor = MAIN_THEME_COLOR;
        self.headLabel.text = @"装货在途";
    }
    return _headLabel;
}

#pragma mark -- ButtonAction

- (IBAction)telePhoneAction:(UIButton *)sender {
    NSString *str=[NSString stringWithFormat:@"telprompt://%@", @"021-66188125"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


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
            NSLog(@"%@", scanResult);
            
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
    NSLog(@"%@", sender.currentTitle);
}

- (void)dealloc {
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
