//
//  HUToast.m
//  Pods
//
//  Created by jewelz on 16/4/30.
//
//

#import "HUToast.h"
#import "hu_const.h"
#import "UIView+frame.h"

const static NSTimeInterval kDefaultDuration = 1.0;

@interface HUToast ()

@property (nonatomic, strong) UILabel *msgLab;
@property (nonatomic, assign) BOOL didHiden;

@end

@implementation HUToast

+ (instancetype)toast {
    static HUToast *toast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toast = [[self alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2, (kScreenHeight-50)/2, 100, 30)];
        toast.msgLab = [[UILabel alloc] initWithFrame:toast.bounds];
        toast.msgLab.textColor = [UIColor whiteColor];
        toast.msgLab.font = [UIFont systemFontOfSize:13];
        toast.msgLab.numberOfLines = 0;
        toast.msgLab.textAlignment = NSTextAlignmentCenter;
        [toast addSubview:toast.msgLab];
        toast.didHiden = YES;
    });
    return toast;
}

+ (void)showToastWithMsg:(NSString *)msg {
    [[HUToast toast] showToastWithMsg:msg];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 6;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.alpha = 0;
    }
    return self;
}

- (void)showToastWithMsg:(NSString *)msg {
    if (!self.didHiden) {
        return;
    }
    
    CGFloat width = [msg sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width+16;
    self.width = width;
    self.msgLab.width = width;
    self.msgLab.text = msg;
    [self showToast];
}
- (void)showToast {
    self.didHiden = NO;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:[HUToast toast]];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [NSTimer scheduledTimerWithTimeInterval:kDefaultDuration target:self selector:@selector(hideToash:) userInfo:nil repeats:NO];
        }
    }];
}

- (void)hideToash:(NSTimer *)timer {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            self.didHiden = YES;
            [timer invalidate];
        }
    }];
}

@end
