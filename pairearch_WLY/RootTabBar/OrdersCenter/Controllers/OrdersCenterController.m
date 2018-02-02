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


@interface OrdersCenterController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (nonatomic, strong) UIButton *selectedBtn;  //已经选中的Button

@property (nonatomic, strong) OrdersCollectionCell *currentCell;  //当前显示的cell

@end

@implementation OrdersCenterController

#pragma mark -- LazyLoding

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xfdf6de);

    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    for (NSInteger i = 0; i < 2; i++) {
        UIButton *btn = (UIButton *)[self.selectView viewWithTag:(100 + i)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xdc3259) forState:UIControlStateSelected];
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
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.collectionView reloadData];
}

#pragma mark -- ButtonActions
- (IBAction)selectButtonAction:(UIButton *)sender {
    if (self.selectedBtn != sender) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(sender.tag - 100) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark -- CommoMethods
/*
- (void)resetMarkViewPositionWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.2 animations:^{
        self.markView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.selectView.bounds) * index / 4.0, 0.0);
    }];
}
 */

#pragma mark -- DelegateMethods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.bounds.size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrdersCollectionCell *cell = [OrdersCollectionCell getCellWithCollectionView:collectionView indexPath:indexPath pushBlock:^(NSArray *selectModelArr, NSIndexPath *indexPath) {
        
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    OrdersCollectionCell *collectionCell = (OrdersCollectionCell *)cell;
//    [collectionCell loadDataFromNet];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        NSInteger index = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
//        [self resetMarkViewPositionWithIndex:index];
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
