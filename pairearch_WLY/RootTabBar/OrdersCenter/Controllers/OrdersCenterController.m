//
//  OrdersCenterController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrdersCenterController.h"

#import "OrdersCollectionCell.h"
#import "OrderListModel.h"
#import "OrderStatusKA212Controller.h"
#import "OrderStatusKA220Controller.h"
#import "OrderStatusKA226Controller.h"
#import "OrderStatusKA228Controller.h"
#import "OrderStatusKA230Controller.h"
#import "OrderStatusKA238Controller.h"
#import "NestedSelectStateController.h"
#import "OrderStatusKA245Controller.h"
#import "BACKNestedSelectController.h"

#import "OrderStatusCOMMON212Controller.h"
#import "OrderStatusCOMMON220Controller.h"
#import "OrderStatusCOMMON226Controller.h"
#import "OrderStatusCOMMON228Controller.h"
#import "CommonSelectStateController.h"


@interface OrdersCenterController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (nonatomic, strong) UIButton *selectedBtn;  //已经选中的Button

@property (nonatomic, strong) UIView *markView; //按钮标记view

@property (nonatomic, strong) OrdersCollectionCell *currentCell;  //当前显示的cell

@end

@implementation OrdersCenterController

#pragma mark -- LazyLoding

- (UIView *)markView {
    if (!_markView) {
        self.markView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.selectView.bounds) - 2, kScreenWidth / 4.0, 2)];
        self.markView.backgroundColor = MAIN_THEME_COLOR;
    }
    return _markView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xCBC9C7);

    self.collectionView.pagingEnabled = YES;
    [self.selectView addSubview:self.markView];
        
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *btn = (UIButton *)[self.selectView viewWithTag:(100 + i)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:MAIN_THEME_COLOR forState:UIControlStateSelected];
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
        } else {
            btn.selected = NO;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark -- ButtonActions
- (IBAction)selectButtonAction:(UIButton *)sender {
    if (self.selectedBtn != sender) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(sender.tag - 100) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    [self resetMarkViewPositionWithIndex:sender.tag - 100];
}

#pragma mark -- CommoMethods

- (void)resetMarkViewPositionWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.2 animations:^{
        self.markView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.selectView.bounds) * index / 4.0, 0.0);
    }];
}

#pragma mark -- DelegateMethods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 47);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrdersCollectionCell *cell = [OrdersCollectionCell getCellWithCollectionView:collectionView indexPath:indexPath pushBlock:^(NSArray *selectModelArr, NSIndexPath *indexPath) {
        
    }];
    cell.indexPath = indexPath;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    OrdersCollectionCell *collectionCell = (OrdersCollectionCell *)cell;
    [MJRefreshUtil begainRefresh:collectionCell.listTableView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        NSInteger index = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
        [self resetMarkViewPositionWithIndex:index];
        UIButton *btn = (UIButton *)[self.selectView viewWithTag:(100 + index)];
        if (index + 100 == btn.tag) {
            [self selectButtonAction:btn];
        }
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
