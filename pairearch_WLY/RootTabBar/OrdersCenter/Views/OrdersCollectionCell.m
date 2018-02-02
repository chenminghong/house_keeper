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
#import "ListHeaderView.h"
#import "ListOtherCell.h"

#define HEADER_IDENTIFIER  @"headerView"

@implementation OrdersCollectionCell

//加载cell
+ (instancetype)getCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath pushBlock:(PushActionBlock)pushBlock {
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
    [collectionView registerClass:[OrdersCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    OrdersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.item = indexPath.item;
    cell.pushBlock = pushBlock;
    cell.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:cell.tableView];
    
    cell.listModelArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        OrderListModel *model = [OrderListModel new];
        [cell.listModelArr addObject:model];
        NSMutableArray *modelArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 6; i++) {
            OrderListModel *tempModel = [OrderListModel new];
            [modelArr addObject:tempModel];
        }
        model.modelListArr = modelArr;
    }
    return cell;
}

#pragma mark -- LazyLoding

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.bottom.and.right.mas_equalTo(self);
        }];
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.sectionHeaderHeight = 0.000001;
        self.tableView.sectionFooterHeight = 0.000001;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
        [MJRefreshUtil pullDownRefresh:self andScrollView:self.tableView andAction:@selector(loadDataFromNet)];
    }
    return _tableView;
}

- (void)setItem:(NSInteger)item {
    _item = item;
//    NSArray *typeArr = @[@"候补", @"侧帘", @"货柜", @"卡板"];
//    self.type = typeArr[item];
    NSArray *urlArr = @[FACT_LOAD_LIST_API, FACT_DISH_LIST_API];
    self.url = urlArr[item];
}

- (void)setListModelArr:(NSMutableArray *)listModelArr {
    _listModelArr = listModelArr;
}

//  请求网络数据
- (void)loadDataFromNet {
    [self.listModelArr removeAllObjects];
    NSDictionary *paraDict = @{@"sourceCode":[LoginModel shareLoginModel].code,
                               OPERATION_KEY:self.url
                               };
    [OrderListModel getDataWithUrl:PAIREACH_NETWORK_URL parameters:paraDict hudTarget:self endBlock:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [MJRefreshUtil endRefresh:self.tableView];
    }];
}


#pragma marks -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listModelArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OrderListModel *model = self.listModelArr[section];
    if (model.isFolded) {
        return 0;
    }
    return [model.modelListArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ListHeaderView *headerView = [ListHeaderView getHeaderViewWithTable:tableView section:section iconBlock:^(NSInteger section) {
        NSLog(@"%@", [NSString stringWithFormat:@"点击了第%ld个分区", section]);
        [self.tableView reloadData];
    }];
    headerView.item = self.item;
    headerView.orderListModel = self.listModelArr[section];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.item == 0) {
        ListTableCell *cell = [ListTableCell getCellWithTable:tableView];
//        OrderListModel *model = self.listModelArr[indexPath.section];
//        cell.orderModel = model.modelListArr[indexPath.row];
        return cell;
    }
    ListOtherCell *cell = [ListOtherCell getCellWithTable:tableView];
//    OrderListModel *model = self.listModelArr[indexPath.section];
//    cell.orderModel = model.modelListArr[indexPath.row];
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
