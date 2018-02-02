//
//  ListHeaderView.m
//  pairearch_WLY
//
//  Created by Jean on 2017/11/10.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "ListHeaderView.h"

#import "OrderListModel.h"

@implementation ListHeaderView

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.width -= 20;
    frame.size.height -= 10;
    [super setFrame:frame];
}

+ (ListHeaderView *)getHeaderViewWithTable:(UITableView *)tableView section:(NSInteger)section iconBlock:(IconBtnBlock)iconBlock {
    ListHeaderView *headView = [[ListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50.0)];
    headView.section = section;
    headView.iconBlock = iconBlock;
    return headView;
}

- (void)setItem:(NSInteger)item {
    _item = item;
    if (item == 0) {
        self.timeLabel.hidden = YES;
        self.wharfNameLabel.hidden = YES;
        self.stateLabel.text = @"催促入厂";
    } else {
        self.timeLabel.hidden = NO;
        self.wharfNameLabel.hidden = NO;
        self.stateLabel.text = @"车牌号";
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.stateLabel];
        [self.contentView addSubview:self.iconBtn];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.wharfNameLabel];
        self.contentView.backgroundColor = UIColorFromRGB(0x00a7eb);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [CAShapeLayer new];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    return self;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.frame) * 60.0 / 320.0, CGRectGetHeight(self.bounds))];
        self.stateLabel.adjustsFontSizeToFitWidth = YES;
        self.stateLabel.minimumScaleFactor = 0.5;
        self.stateLabel.font = [UIFont systemFontOfSize:16.0];
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.textColor = [UIColor whiteColor];
        self.stateLabel.text = @"催促入厂";
    }
    return _stateLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.stateLabel.frame), 0, CGRectGetWidth(self.frame) * 75.0 / 320.0, CGRectGetHeight(self.bounds))];
        self.timeLabel.adjustsFontSizeToFitWidth = YES;
        self.timeLabel.minimumScaleFactor = 0.5;
        self.timeLabel.font = [UIFont systemFontOfSize:16.0];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.text = @"签到时间";
    }
    return _timeLabel;
}

- (UILabel *)wharfNameLabel {
    if (!_wharfNameLabel) {
        self.wharfNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLabel.frame), 0, CGRectGetWidth(self.frame) * 75.0 / 320.0, CGRectGetHeight(self.bounds))];
        self.wharfNameLabel.adjustsFontSizeToFitWidth = YES;
        self.wharfNameLabel.minimumScaleFactor = 0.5;
        self.wharfNameLabel.font = [UIFont systemFontOfSize:16.0];
        self.wharfNameLabel.textAlignment = NSTextAlignmentCenter;
        self.wharfNameLabel.textColor = [UIColor whiteColor];
        self.wharfNameLabel.text = @"码头名称";
    }
    return _wharfNameLabel;
}

- (UIButton *)iconBtn {
    if (!_iconBtn) {
        self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.iconBtn.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 40, CGRectGetMidY(self.bounds) - 15.0, 30, 30);
        self.iconBtn.selected = NO;
        [self.iconBtn addTarget:self action:@selector(iconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.iconBtn setImage:[UIImage imageNamed:@"xiangxia"] forState:UIControlStateNormal];
    }
    return _iconBtn;
}

- (void)setOrderListModel:(OrderListModel *)orderListModel {
    _orderListModel = orderListModel;
    if (orderListModel.isFolded) {
        if (!CGAffineTransformIsIdentity(self.iconBtn.imageView.transform)) {
            self.iconBtn.imageView.transform = CGAffineTransformIdentity;
        }
    } else {
        self.iconBtn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
    }
}


- (void)iconButtonAction:(UIButton *)sender {
    self.orderListModel.isFolded = !self.orderListModel.isFolded;
    if (self.iconBlock) {
        self.iconBlock(self.section);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
