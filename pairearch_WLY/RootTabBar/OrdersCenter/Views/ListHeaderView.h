//
//  ListHeaderView.h
//  pairearch_WLY
//
//  Created by Jean on 2017/11/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderListModel;

typedef void(^IconBtnBlock)(NSInteger section);

@interface ListHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) UILabel *stateLabel;  //状态标签
@property (nonatomic, strong) UILabel *timeLabel;   //签到时间标签
@property (nonatomic, strong) UILabel *wharfNameLabel;  //码头名称Label
@property (strong, nonatomic) UIButton *iconBtn;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger item;   //在第几个table里面
@property (nonatomic, strong) OrderListModel *orderListModel;

@property (nonatomic, copy) IconBtnBlock iconBlock;


/**
 生成分区表头视图

 @param section 表头分区位置
 @param tableView 表头分区位置
 @param iconBlock 按钮点击事件
 @return 返回对应的表头对象
 */
+ (ListHeaderView *)getHeaderViewWithTable:(UITableView *)tableView section:(NSInteger)section iconBlock:(IconBtnBlock)iconBlock;

@end
