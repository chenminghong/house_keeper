//
//  PersonalHeaderView.h
//  pairearch_WLY
//
//  Created by Jean on 2017/11/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *userIconButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nextIconImg;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

+ (instancetype)getHeaderView;

@end
