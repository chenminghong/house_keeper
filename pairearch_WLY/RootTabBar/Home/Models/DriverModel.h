//
//  DriverModel.h
//  pairearch_WLY
//
//  Created by Jean on 2017/5/9.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface DriverModel : BaseModel

@property (nonatomic, copy) NSString *driverTel;    //司机手机号

@property (nonatomic, copy) NSString *truckNumber;  //车牌号

+ (NSURLSessionDataTask *)loadDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock;

@end
