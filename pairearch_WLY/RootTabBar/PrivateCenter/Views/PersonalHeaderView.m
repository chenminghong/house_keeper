//
//  PersonalHeaderView.m
//  pairearch_WLY
//
//  Created by Jean on 2017/11/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "PersonalHeaderView.h"

@implementation PersonalHeaderView

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0xf5bf43).CGColor,
                                      (__bridge id)UIColorFromRGB(0xda9b18).CGColor];
        self.gradientLayer.locations = @[@0.0, @1.0];
        self.gradientLayer.startPoint = CGPointMake(0, 0);
        self.gradientLayer.endPoint = CGPointMake(0, 1.0);
        self.gradientLayer.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.bounds));
    }
    return _gradientLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
    NSLog(@"%@", NSStringFromCGRect(self.gradientLayer.frame));
    
    self.userIconButton.layer.masksToBounds = YES;
    self.userIconButton.layer.cornerRadius = (kScreenWidth * 60.0 / 320.0) / 2.0;
    self.userIconButton.layer.borderColor = UIColorFromRGB(0xfae4b2).CGColor;
    self.userIconButton.layer.borderWidth = 2.0;
}

+ (instancetype)getHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"PersonalHeaderView" owner:self options:nil] firstObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}
*/

@end
