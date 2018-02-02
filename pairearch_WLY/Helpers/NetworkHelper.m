//
//  NetworkHelper.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper

+ (instancetype)shareClient {
    static NetworkHelper *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [NetworkHelper new];
        sharedClient = [[NetworkHelper alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
//        sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [sharedClient.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"x-requested-with"];
        sharedClient.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    });
    return sharedClient;
}

+ (instancetype)shareClientOther {
    static NetworkHelper *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[NetworkHelper alloc] initWithBaseURL:nil];
        //        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //        [_sharedClient.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"x-requested-with"];
        sharedClient.requestSerializer.timeoutInterval = REQUEST_TIMEOUT;
    });
    
    return sharedClient;
}

//判断网络状态
+ (NetworkReachabilityStatus)localizedNetworkReachabilityStatus {
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            return NetworkReachabilityStatusNotReachable;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return NetworkReachabilityStatusReachableViaWWAN;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return NetworkReachabilityStatusReachableViaWiFi;
        case AFNetworkReachabilityStatusUnknown:
        default:
            return NetworkReachabilityStatusUnknown;
    }
}

// 判断网络类型
+ (NetworkStatus)getNetworkStatus {
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    // 保存网络状态
    NetworkStatus status = NetworkStatusNone;
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    status = NetworkStatusNone;
                    //无网模式
                    break;
                case 1:
                    status = NetworkStatus2G;
                    break;
                case 2:
                    status = NetworkStatus3G;
                    break;
                case 3:
                    status = NetworkStatus4G;
                    break;
                case 5:
                    status = NetworkStatusWIFI;
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return status;
}

+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))progress endResult:(EndResultBlock)endResult {
    NSDictionary *tempParaDict = [BaseModel parametersTransformationWithRequestEntityDict:parameters];
    return [[NetworkHelper shareClient] GET:URLString parameters:tempParaDict progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self analysisDataWithTask:task responseObject:responseObject error:nil hudTarget:nil endResult:endResult];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self analysisDataWithTask:task responseObject:nil error:error hudTarget:nil endResult:endResult];
    }];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))progress endResult:(EndResultBlock)endResult {
    NSDictionary *tempParaDict = [BaseModel parametersTransformationWithRequestEntityDict:parameters];
    return [[NetworkHelper shareClient] POST:URLString parameters:tempParaDict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self analysisDataWithTask:task responseObject:responseObject error:nil hudTarget:nil endResult:endResult];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self analysisDataWithTask:task responseObject:nil error:error hudTarget:nil endResult:endResult];
    }];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *uploadProgress))progress endResult:(EndResultBlock)endResult {
    NSDictionary *tempParaDict = [BaseModel parametersTransformationWithRequestEntityDict:parameters];
    return [[NetworkHelper shareClient] POST:URLString parameters:tempParaDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self analysisDataWithTask:task responseObject:responseObject error:nil hudTarget:nil endResult:endResult];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self analysisDataWithTask:task responseObject:nil error:error hudTarget:nil endResult:endResult];
    }];
}


/* 以下方法自带展示通用HUD提示功能 */

//get请求
+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters hudTarget:(id)hudTarget progress:(void (^)(NSProgress *progress))progress endResult:(EndResultBlock)endResult {
    NSDictionary *tempParaDict = [BaseModel parametersTransformationWithRequestEntityDict:parameters];
    __weak UIView *hudView = [self getHudViewWithTarget:hudTarget];
    __weak MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:hudView title:kBWMMBProgressHUDMsgLoading animated:YES];
    return [[NetworkHelper shareClient] GET:URLString parameters:tempParaDict progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        [self analysisDataWithTask:task responseObject:responseObject error:nil hudTarget:hudView endResult:endResult];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:NO];
        [self analysisDataWithTask:task responseObject:nil error:error hudTarget:hudView endResult:endResult];
    }];
}

//post请求
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters hudTarget:(id)hudTarget progress:(void (^)(NSProgress *progress))progress endResult:(EndResultBlock)endResult {
    NSDictionary *tempParaDict = [BaseModel parametersTransformationWithRequestEntityDict:parameters];
    __weak UIView *hudView = [self getHudViewWithTarget:hudTarget];
    __weak MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:hudView title:kBWMMBProgressHUDMsgLoading animated:YES];
    return [[NetworkHelper shareClient] POST:URLString parameters:tempParaDict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:NO];
        [self analysisDataWithTask:task responseObject:responseObject error:nil hudTarget:hudView endResult:endResult];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:NO];
        [self analysisDataWithTask:task responseObject:nil error:error hudTarget:hudView endResult:endResult];
    }];
}

//post请求(上传文件)
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters hudTarget:(id)hudTarget constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *uploadProgress))progress endResult:(EndResultBlock)endResult {
    NSDictionary *tempParaDict = [BaseModel parametersTransformationWithRequestEntityDict:parameters];
    __weak UIView *hudView = [self getHudViewWithTarget:hudTarget];
    __weak MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:hudView title:kBWMMBProgressHUDMsgLoading animated:YES];
    return [[NetworkHelper shareClient] POST:URLString parameters:tempParaDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            [hud hide:NO];
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:NO];
        [self analysisDataWithTask:task responseObject:responseObject error:nil hudTarget:hudView endResult:endResult];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:NO];
        [self analysisDataWithTask:task responseObject:nil error:error hudTarget:hudView endResult:endResult];
    }];
}

//根据当前请求返回数据整体框架结构自定义数据解析方法
+ (void)analysisDataWithTask:(NSURLSessionDataTask *)task
              responseObject:(id)responseObject
                       error:(NSError *)error
                   hudTarget:(UIView *)hudTarget
                   endResult:(EndResultBlock)endResult
{
    
    if (!endResult) {
        return;
    }
    if (error) {
        if (hudTarget) {
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:hudTarget hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        endResult(task, nil, error);
        return;
    }
    NSError *tempError = nil;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&tempError];
    if (!tempError) {
        BOOL resultFlag = [[responseDict objectForKey:RESULT_FLAG_KEY] boolValue];
        //如果resultFlag是NO，请求数据错误，YES说明请求成功
        if (resultFlag) {
            NSDictionary *dataDict = responseDict[RESPONSE_ENTITY_KEY];
            endResult(task, dataDict, nil);
        } else {
            NSString *message = [responseDict[MESSAGE_KEY] length] > 0? responseDict[MESSAGE_KEY]:@"";
            if (hudTarget) {
                [MBProgressHUD bwm_showTitle:message toView:hudTarget hideAfter:HUD_HIDE_TIMEINTERVAL];
            }
            endResult(task, nil, [NSError errorWithDomain:BASE_URL code:resultFlag userInfo:@{ERROR_MSG:message}]);
        }
    } else {
        if (hudTarget) {
            [MBProgressHUD bwm_showTitle:tempError.userInfo[ERROR_MSG] toView:hudTarget hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        endResult(task, nil, tempError);
    }
}

+ (UIView *)getHudViewWithTarget:(id)target {
    if (target) {
        if ([target isKindOfClass:[UIViewController class]]) {
            UIViewController *tempVC = target;
            return tempVC.view;
        } else if ([target isKindOfClass:[UIView class]]) {
            return target;
        }
        return [UIApplication sharedApplication].keyWindow;
    }
    return [UIApplication sharedApplication].keyWindow;
}


@end
