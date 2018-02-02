//
//  NetworkHelper.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//网络请求超时的时间
#define REQUEST_TIMEOUT 15.0f

//baseUrl
#define BASE_URL  @"http://106.14.39.65:8285/itip/client/"

typedef NS_ENUM(NSUInteger, NetworkReachabilityStatus) {
    NetworkReachabilityStatusUnknown          = -1,
    NetworkReachabilityStatusNotReachable     = 0,
    NetworkReachabilityStatusReachableViaWWAN = 1,
    NetworkReachabilityStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSUInteger, NetworkStatus) {
    NetworkStatusNone = 0, // 没有网络
    NetworkStatus2G, // 2G
    NetworkStatus3G, // 3G
    NetworkStatus4G, // 4G
    NetworkStatusWIFI // WIFI
};

typedef void(^EndResultBlock)(NSURLSessionDataTask *task, id responseObject, NSError *error);

@interface NetworkHelper : AFHTTPSessionManager

//init
+ (instancetype)shareClient;

//判断网络状态
+ (NetworkReachabilityStatus)localizedNetworkReachabilityStatus;

//判断网络类型
+ (NetworkStatus)getNetworkStatus;

//get请求
+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *progress))progress endResult:(EndResultBlock)endResult;

//post请求
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *progress))progress endResult:(EndResultBlock)endResult;

//post请求(上传文件)
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *uploadProgress))progress endResult:(EndResultBlock)endResult;

//target是当前请求的View或者ViewController, 用来展示当前的HUD提示

//get请求
+ (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters hudTarget:(id)hudTarget progress:(void (^)(NSProgress *progress))progress endResult:(EndResultBlock)endResult;

//post请求
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters hudTarget:(id)hudTarget progress:(void (^)(NSProgress *progress))progress endResult:(EndResultBlock)endResult;

//post请求(上传文件)
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters hudTarget:(id)hudTarget constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *uploadProgress))progress endResult:(EndResultBlock)endResult;

@end
