//
//  EntryCertificatesController.m
//  pairearch_WLY
//
//  Created by Jean on 2017/11/29.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "EntryCertificatesController.h"

#import "CertificatesTableCell.h"
#import "FooterButtonView.h"

@interface EntryCertificatesController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) FooterButtonView *footerButtonView;

@property (nonatomic, strong) NSArray *urlStrArr;

@end

@implementation EntryCertificatesController

- (FooterButtonView *)footerButtonView {
    if (!_footerButtonView) {
        self.footerButtonView = [FooterButtonView getFooterViewWithButtonAction:^(UIButton *button) {
            [self clickButtonAction:button];
        }];
        self.footerButtonView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    }
    return _footerButtonView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     self.urlStrArr = @[@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1238497980,1597218505&fm=26&gp=0.jpg",
     @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1450410798,281036268&fm=26&gp=0.jpg",
     @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3503460854,933931965&fm=26&gp=0.jpg",
     @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1128343348,3478453008&fm=26&gp=0.jpg"];
    
    self.tableView.tableFooterView = self.footerButtonView;
}

- (void)setUrlStrArr:(NSArray *)urlStrArr {
    _urlStrArr = urlStrArr;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.urlStrArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kScreenWidth - 40) * 54.0 / 86.0 + 92;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CertificatesTableCell *cell = [CertificatesTableCell getCellWithTable:tableView indexPath:indexPath tapImgBlock:^(CertificatesTableCell *cell, NSInteger row) {
        HUPhotoBrowser *browser = [HUPhotoBrowser showFromImageView:cell.certificatesImgView withURLStrings:self.urlStrArr atIndex:row];
        UIView *toolBarview = [browser valueForKey:@"toolBar"];
        for (UIView *subView in toolBarview.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *downLoadBtn = (UIButton *)subView;
                [downLoadBtn setImage:[UIImage imageNamed:@"tupianxiazai"] forState:UIControlStateNormal];
            }
        }
    }];
    cell.imgUrlStr = self.urlStrArr[indexPath.row];
    return cell;
}

#pragma mark -- ButtonAction

- (void)clickButtonAction:(UIButton *)sender {
    switch (sender.tag) {
        case 0: //确定按钮
        {
            NSLog(@"确定操作");
        }
            break;
        case 1: //取消按钮
        {
            NSLog(@"取消操作");
        }
            break;
            
        default:
            break;
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
