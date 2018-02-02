//
//  FooterButtonView.m
//  pairearch_WLY
//
//  Created by Jean on 2017/11/30.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "FooterButtonView.h"

@implementation FooterButtonView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.sureButton.layer.cornerRadius = 5.0;
    self.sureButton.backgroundColor = MAIN_BUTTON_BGCOLOR;
    self.cancelButton.layer.cornerRadius = 5.0;
    self.cancelButton.layer.borderWidth = 1.0;
    self.cancelButton.layer.borderColor = MAIN_BUTTON_BGCOLOR.CGColor;
}

+ (instancetype)getFooterViewWithButtonAction:(ButtonActionBlock)buttonAction {
    FooterButtonView *footerView = [[[NSBundle mainBundle] loadNibNamed:@"FooterButtonView" owner:self options:nil] firstObject];
    footerView.buttonAction = buttonAction;
    return footerView;
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (self.buttonAction) {
        self.buttonAction(sender);
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
