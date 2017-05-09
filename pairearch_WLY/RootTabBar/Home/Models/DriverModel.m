//
//  DriverModel.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/9.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "DriverModel.h"

@implementation DriverModel

+ (NSURLSessionDataTask *)getDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [NetworkHelper POST:HOME_ORDER_CHECK_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger result = [responseObject[@"result"] integerValue];
        NSDictionary *driverDict = responseObject[@"order"];
        if ([driverDict allKeys].count > 0) {
            DriverModel *driverModel = [DriverModel getModelWithDict:driverDict];
            endBlock(driverModel, nil);
        } else {
            NSError *error = [NSError errorWithDomain:PAIREACH_BASE_URL code:result userInfo:@{ERROR_MSG:@"该订单不存在"}];
            endBlock(nil, error);
        }
    } failure:^(NSError *error) {
        endBlock(nil, error);
    }];
}

@end
