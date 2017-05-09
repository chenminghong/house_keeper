//
//  CommonPickerView.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "CommonPickerView.h"

@implementation CommonPickerView

+ (CommonPickerView *)getPickerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CommonPickerView" owner:self options:nil] firstObject];
}

+ (CommonPickerView *)showPickerViewInView:(UIView *)view titleList:(NSArray *)titleList pickBlock:(PickerViewBlock)pickBlock {
    UIView *view1 = [[UIView alloc] initWithFrame:view.bounds];
    [view addSubview:view1];
    
    CommonPickerView *pickerView = [self getPickerView];
    pickerView.backgroundColor = [UIColor clearColor];
    pickerView.frame = view.bounds;
    pickerView.pickerView.backgroundColor = TOP_BOTTOMBAR_COLOR;
    pickerView.pickBlock = pickBlock;
    pickerView.dataList = titleList;
    [pickerView.pickerView reloadAllComponents];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:pickerView action:@selector(hidePickerView)];
    [pickerView addGestureRecognizer:tap];

    [UIView transitionFromView:view1 toView:pickerView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve completion:nil];
    
    return pickerView;
}

- (void)hidePickerView {
    UIView *view1 = [[UIView alloc] initWithFrame:self.bounds];
    
    [UIView transitionFromView:self toView:view1 duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        if (finished) {
            [view1 removeFromSuperview];
        }
    }];
}

- (IBAction)completeButtonAction:(UIButton *)sender {
    if (self.pickBlock) {
        NSInteger selectRow = [self.pickerView selectedRowInComponent:0];
        self.pickBlock(self.dataList[selectRow]);
        [self hidePickerView];
    }
}

- (void)setSelectedRowWithSelectedTitle:(NSString *)selectedTitle {
    for (NSInteger index = 0; index < self.dataList.count; index++) {
        NSString *title = self.dataList[index];
        if ([title isEqualToString:title]) {
            [self.pickerView selectRow:index inComponent:0 animated:NO];
            break;
        }
    }
}



#pragma mark -- Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataList.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataList[row];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
