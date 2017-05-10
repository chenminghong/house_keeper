//
//  OrderListModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.flateModelArr = [NSMutableArray array];
    }
    return self;
}

+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict endBlock:(void (^)(id, NSError *))endBlock {
    return [NetworkHelper GET:url parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, MBProgressHUD *hud, id responseObject) {
        if (!endBlock) {
            return;
        }
        NSArray *listArr = [NSArray arrayWithArray:responseObject];
        //如果resultFlag是NO，说明用户名和密码不正确，直接return
        if (listArr.count <= 0) {
            [hud hide:NO];
            NSString *msg = @"暂无数据";
            endBlock(nil, [NSError errorWithDomain:PAIREACH_BASE_URL code:0 userInfo:@{ERROR_MSG:msg}]);
        } else {
            [hud hide:YES];
            OrderListModel *model = [OrderListModel new];
            for (NSString *flateNumber in listArr) {
                NSDictionary *flateDict = @{@"plateNumber":flateNumber};
                OrderListModel *flateModel = [OrderListModel getModelWithDict:flateDict];
                [model.flateModelArr addObject:flateModel];
            }
            endBlock(model, nil);
        }
    } failure:^(NSError *error) {
        if (endBlock) {
            endBlock(nil, error);
        }
    }];
}
@end
