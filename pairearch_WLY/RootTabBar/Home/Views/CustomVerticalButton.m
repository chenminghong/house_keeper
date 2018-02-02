//
//  CustomVerticalButton.m
//  pairearch_WLY
//
//  Created by Jean on 2017/8/21.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "CustomVerticalButton.h"

@implementation CustomVerticalButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat innerMargin = 20.0;
    CGFloat imgWidth = CGRectGetHeight(self.bounds) / 2.0;
    CGRect labelFrame = self.titleLabel.frame;
    
    NSDictionary *attrs = @{NSFontAttributeName:self.titleLabel.font};
    CGSize textSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, labelFrame.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    
    self.imageView.frame = CGRectMake(CGRectGetWidth(self.bounds)/3.0 - imgWidth - innerMargin / 2.0, CGRectGetMidY(self.bounds) - imgWidth / 2.0, imgWidth, imgWidth);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //Center text
    self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.frame)/3.0 + innerMargin / 2.0, CGRectGetMidY(self.bounds) - CGRectGetHeight(labelFrame)/2.0, textSize.width, CGRectGetHeight(labelFrame));
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
