//
//  DriverModel.m
//  pairearch_WLY
//
//  Created by Jean on 2017/5/9.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "DriverModel.h"

@implementation DriverModel

+ (NSURLSessionDataTask *)loadDataWithParameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [[NetworkHelper shareClient] POST:HOME_ORDER_CHECK_API parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSInteger result = [responseDict[@"result"] integerValue];
        NSDictionary *driverDict = responseDict[@"order"];
        if ([driverDict allKeys].count > 0) {
            DriverModel *driverModel = [DriverModel getModelWithDict:driverDict];
            endBlock(driverModel, nil);
        } else {
            NSError *error = [NSError errorWithDomain:BASE_URL code:result userInfo:@{ERROR_MSG:@"该订单不存在"}];
            endBlock(nil, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        endBlock(nil, error);
    }];
}

@end
