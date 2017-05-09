//
//  PlateNumbersController.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/9.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseViewController.h"

@class DriverModel;

@interface PlateNumbersController : BaseViewController

@property (nonatomic, copy) NSString *orderCode;          //运单号

@property (nonatomic, strong) DriverModel *driverModel;   //司机数据模型

@end
