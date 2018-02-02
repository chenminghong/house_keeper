//
//  NavigationController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = TOP_NAVIBAR_COLOR;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xffffff), NSFontAttributeName:[UIFont systemFontOfSize:20.0]}];
    
    //隐藏navigationBar底部线条
    [self hideNavigationBarBottomLine];
    
    //添加渐变色
//    [NavigationController setLinearGradientNavigationBackgroundWithNavigationBar:self.navigationBar startColor:UIColorFromRGB(0xe7ac30) endColor:UIColorFromRGB(0xFFB74D)];
}

//隐藏底部线条
- (void)hideNavigationBarBottomLine {
    UIImageView *bottomView = [[self class] findHairlineImageViewUnder:self.navigationBar];
    if (bottomView) {
        bottomView.hidden = YES;
    }
}

/**
 pop返回事件
 */
- (void)popBackAction{
    [self popViewControllerAnimated:YES];
}


/**
 重写父类push函数

 @param viewController to viewController
 @param animated animated
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItems = [[self class] getNavigationBackItemsWithTarget:self SEL:@selector(popBackAction)];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    [viewController.navigationController setNavigationBarHidden:NO animated:YES];
    viewController.title = @"我来运";
}

#pragma marks -- Common Methods

/**
 给导航条绘制渐变背景
 
 @param navigationBar 需要渐变色的导航条
 @param startColor 起始颜色
 @param endColor 终止颜色
 */
+ (void)setLinearGradientNavigationBackgroundWithNavigationBar:(UINavigationBar *)navigationBar
                                                    startColor:(UIColor *)startColor
                                                      endColor:(UIColor *)endColor
{
    //创建CGContextRef
    UIGraphicsBeginImageContext(CGSizeMake(kScreenWidth, 64));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rect = CGRectMake(0, 0, kScreenWidth, 64);
    CGPathAddRect(path, NULL, rect);
    CGPathCloseSubpath(path);
    
    //绘制渐变
    [self drawRadialGradient:context path:path startColor:startColor.CGColor endColor:endColor.CGColor];
    
    CGPathRelease(path);
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];  //设置背景
}


/**
 绘制渐变图形
 
 @param context 图形上下文
 @param path 渐变色路径
 @param startColor 起始颜色
 @param endColor 终止颜色
 */
+ (void)drawRadialGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    CGPoint startPoint = CGPointMake(0, CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

//找到navigationBar底部线条
+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

/**
 给导航栏添加按钮

 @param target 需要添加按钮的ViewController
 @param sel 按钮点击需要调用的函数编码
 @return 需要添加的导航栏按钮
 */
+ (UIBarButtonItem *)getNavigationBackItemWithTarget:(id)target SEL:(SEL)sel {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"fanhui_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return backItem;
}


/**
 生成返回按钮

 @param target 需要添加返回按钮的ViewController
 @param sel 点击返回按钮的函数编码
 @return 返回需要添加的导航栏按钮
 */
+ (NSArray <UIBarButtonItem *>*)getNavigationBackItemsWithTarget:(id)target SEL:(SEL)sel {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"fanhui_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;
    return @[spaceItem, backItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
