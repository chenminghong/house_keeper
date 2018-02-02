//
//  PersonalCenterViewController.m
//  WLY
//
//  Created by Leo on 16/3/15.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "PersonalCenterViewController.h"

#import "AlterPasswordViewController.h"
#import "VersionInfoViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
#import "PersonalCenterCell.h"
#import "CancelLoginCell.h"
#import "PersonalHeaderView.h"
#import "EntryCertificatesController.h"

@interface PersonalCenterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titltArr; //存储title

@property (nonatomic, strong) NSArray *imageNameArr; //存储图片的名字

@property (nonatomic, strong) PersonalHeaderView *headerView; //顶部的用户信息表头视图

@end

@implementation PersonalCenterViewController

- (PersonalHeaderView *)headerView {
    if (!_headerView) {
        self.headerView = [PersonalHeaderView getHeaderView];
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 150);
        self.headerView.userNameLabel.text = [LoginModel shareLoginModel].account;
        self.headerView.userNumberLabel.text = [LoginModel shareLoginModel].name;
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
    //个人中心界面的背景图片
    self.view.backgroundColor = UIColorFromRGB(0xCBC9C7);
    self.title = @"个人中心";
    
    self.titltArr = @[@"修改密码", @"版本信息", @"关于我们"];
    self.imageNameArr = @[@"设置密码", @"版本信息", @"关于我们"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20.0, 0, 0);
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.tableView setSeparatorColor:UIColorFromRGB(0xe6e6e6)];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return self.titltArr.count;
    } else {
        return 1;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (0 == section) {
//        return 150.0;
//    }
//    return CGFLOAT_MIN;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        PersonalCenterCell *cell = [PersonalCenterCell getCellWithTable:tableView];
        cell.mainLabel.text = self.titltArr[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:self.imageNameArr[indexPath.row]];
        return cell;
    } else {
        CancelLoginCell *cell = [CancelLoginCell getCellWithTable:tableView];
        return cell;
    }
}

//点击cell触发
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (indexPath.row == 0) {
            AlterPasswordViewController *alterPasswordVC = [[AlterPasswordViewController alloc] init];
            alterPasswordVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:alterPasswordVC animated:YES];
        } else if (indexPath.row == 1) {
            VersionInfoViewController *versionInfoVC = [[VersionInfoViewController alloc] init];
            versionInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:versionInfoVC animated:YES];
        } else if (indexPath.row == 2){
            AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
            aboutUsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        } else {
            EntryCertificatesController *entryVC = [EntryCertificatesController new];
            [self.navigationController pushViewController:entryVC animated:YES];
        }
    } else {
        [LoginViewController showSelfInController:self completeBlock:nil];
    }
}

//移除观察者
- (void)dealloc {
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
