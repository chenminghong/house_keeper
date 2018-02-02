//
//  FooterButtonView.h
//  pairearch_WLY
//
//  Created by Jean on 2017/11/30.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonActionBlock)(UIButton *button);

@interface FooterButtonView : UIView
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, copy) ButtonActionBlock buttonAction;

+ (instancetype)getFooterViewWithButtonAction:(ButtonActionBlock)buttonAction;

@end
