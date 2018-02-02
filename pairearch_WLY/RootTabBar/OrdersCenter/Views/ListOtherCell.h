//
//  ListOtherCell.h
//  pairearch_WLY
//
//  Created by Jean on 2017/11/28.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderListModel;

@interface ListOtherCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;  //车牌号标签
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialsLabel;
@property (weak, nonatomic) IBOutlet UIButton *enterFacBtn;

@property (nonatomic, strong) OrderListModel *orderModel;               //数据模型


//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table;

@end
