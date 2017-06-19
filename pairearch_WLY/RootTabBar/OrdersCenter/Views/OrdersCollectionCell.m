//
//  OrdersCollectionCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrdersCollectionCell.h"

#import "ListTableCell.h"
#import "OrderListModel.h"

@implementation OrdersCollectionCell

//加载cell
+ (instancetype)getCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath pushBlock:(PushActionBlock)pushBlock {
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%lu", (long)indexPath.item];
    [collectionView registerClass:[OrdersCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    OrdersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.pushBlock = pushBlock;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addSubview:self.listTableView];
}

#pragma mark -- LazyLoding

- (UITableView *)listTableView {
    if (!_listTableView) {
        self.listTableView = [UITableView new];
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.listTableView];
        [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.bottom.and.right.mas_equalTo(self);
        }];
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        self.listTableView.tableFooterView = [UIView new];
        [MJRefreshUtil pullDownRefresh:self andScrollView:self.listTableView andAction:@selector(loadDataFromNet)];
    }
    return _listTableView;
}


- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    NSArray *typeArr = @[@"候补", @"侧帘", @"货柜", @"卡板"];
    self.type = typeArr[indexPath.item];
    NSArray *urlArr = @[WAIT_LIST_API, SIDE_LIST_API, SIDE_LIST_API, SIDE_LIST_API];
    self.url = urlArr[indexPath.item];
}

- (void)setListModelArr:(NSMutableArray *)listModelArr {
    _listModelArr = listModelArr;
}

//  请求网络数据
- (void)loadDataFromNet {
    [self.listModelArr removeAllObjects];
    NSString *url = self.url.length>0? self.url:@"";
    
    [OrderListModel getDataWithUrl:url parameters:@{@"userName":[LoginModel shareLoginModel].loginacct.length>0? [LoginModel shareLoginModel].loginacct:@"", @"passwayName":self.type.length>0? self.type:@""} endBlock:^(id model, NSError *error) {
        if (!error) {
            OrderListModel *flateModel = model;
            self.listModelArr = [NSMutableArray arrayWithArray:flateModel.flateModelArr];
        } else {
            [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.listTableView.superview hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        [self.listTableView reloadData];
        [MJRefreshUtil endRefresh:self.listTableView];
        
    }];
}


#pragma marks -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableCell *cell = [ListTableCell getCellWithTable:tableView];
    cell.orderModel = self.listModelArr[indexPath.row];
    return cell;
}



#pragma mark -- ButtonAction

//拼单按钮点击事件
- (void)pushButtonAction:(UIButton *)sender {
//    if (self.pushBlock) {
//        NSMutableArray *modelArr = [NSMutableArray array];
//        for (OrderListModel *model in self.listModelArr) {
//            if (model.isSelected) {
//                [modelArr addObject:model];
//            }
//        }
//        self.pushBlock(modelArr, self.indexPath);
//    }
}

@end
