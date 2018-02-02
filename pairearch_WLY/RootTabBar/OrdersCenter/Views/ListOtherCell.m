//
//  ListOtherCell.m
//  pairearch_WLY
//
//  Created by Jean on 2017/11/28.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "ListOtherCell.h"

@implementation ListOtherCell

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.enterFacBtn.backgroundColor = MAIN_BUTTON_BGCOLOR;
    self.enterFacBtn.layer.cornerRadius = 5.0;
}


//加载cell
+ (instancetype)getCellWithTable:(UITableView *)table {
    ListOtherCell *cell = [table dequeueReusableCellWithIdentifier:@"ListOtherCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListOtherCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
