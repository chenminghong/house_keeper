//
//  ListTableCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "ListTableCell.h"

#import "OrderListModel.h"

@implementation ListTableCell

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.width -= 20;
    frame.size.height -= 20;
    [super setFrame:frame];
}

//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    ListTableCell *cell = [table dequeueReusableCellWithIdentifier:@"ListTableCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListTableCell" owner:self options:nil] firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置阴影
    cell.layer.masksToBounds = NO;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.layer setMasksToBounds:YES];
    self.layer.cornerRadius = 5;
}

- (void)setOrderModel:(OrderListModel *)orderModel {
    _orderModel = orderModel;
    self.plateNumberLabel.text = [NSString stringWithFormat:@"%@", orderModel.plateNumber];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
