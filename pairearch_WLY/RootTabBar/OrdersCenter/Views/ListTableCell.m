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
    frame.size.width -= 20;
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
//    cell.layer.masksToBounds = NO;
//    cell.layer.shadowColor = [UIColor blackColor].CGColor;
//    cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    cell.layer.shadowOpacity = 0.5f;
//    cell.layer.shouldRasterize = YES;
//    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.enterFacBtn.backgroundColor = MAIN_BUTTON_BGCOLOR;
    self.enterFacBtn.layer.cornerRadius = 5.0;
}

- (void)setOrderModel:(OrderListModel *)orderModel {
    _orderModel = orderModel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
