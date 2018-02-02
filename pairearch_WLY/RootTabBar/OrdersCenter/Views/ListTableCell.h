//
//  ListTableCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderListModel;


@interface ListTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;  //车牌号标签
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *enterFacBtn;

@property (nonatomic, strong) OrderListModel *orderModel;               //数据模型

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
