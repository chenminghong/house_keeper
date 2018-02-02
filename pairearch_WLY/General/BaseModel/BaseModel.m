//
//  BaseModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

#import <CommonCrypto/CommonDigest.h>
//获取Mac地址需要头文件
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//获取设备型号
#import <sys/utsname.h>

//获取SIM卡信息
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <dlfcn.h>


#define SERVERKEY @"52a5dad279cd11e4b5ea0016maxinlin"

@implementation BaseModel

#pragma mark -- 初始化数据
//实例方法初始化
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if (!value) {
        value = @"";
    }
    if (![value isKindOfClass:[NSArray class]] &&
        ![value isKindOfClass:[NSDictionary class]]) {
        value = [NSString stringWithFormat:@"%@", value];
    }
    [super setValue:value forKey:key];
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

//类方法初始化
+ (instancetype)getModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

//返回Models数组
+ (NSArray *)getModelsWithDicts:(NSArray *)dicts {
    NSMutableArray *modelsArr = [NSMutableArray array];
    for (NSDictionary *modelDict in dicts) {
        [modelsArr addObject:[self getModelWithDict:modelDict]];
    }
    return modelsArr;
}

#pragma mark -- 数据请求
//GET请求
+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict endBlock:(EndResultBlock)endBlock {
    return [NetworkHelper GET:url parameters:paramDict progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [self initializationDataModelWithTask:task responseObject:responseObject error:error endResult:endBlock];
    }];
}

+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict hudTarget:(id)hudTarget endBlock:(EndResultBlock)endBlock {
    return [NetworkHelper GET:url parameters:paramDict hudTarget:hudTarget progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [self initializationDataModelWithTask:task responseObject:responseObject error:error endResult:endBlock];
    }];
}

/*
+ (NSURLSessionDataTask *)getDataWithOperation:(NSString *)operation parameters:(NSDictionary *)paramDict endBlock:(EndResultBlock)endBlock {
    return [NetworkHelper GET:PAIREACH_BASE_URL parameters:paramDict progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [self initializationDataModelWithTask:task responseObject:responseObject error:error endResult:endBlock];
    }];
}

+ (NSURLSessionDataTask *)getDataWithOperation:(NSString *)operation parameters:(NSDictionary *)paramDict hudTarget:(id)hudTarget endBlock:(EndResultBlock)endBlock {
    return [NetworkHelper GET:PAIREACH_BASE_URL parameters:paramDict hudTarget:hudTarget progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [self initializationDataModelWithTask:task responseObject:responseObject error:error endResult:endBlock];
    }];
}
 */

//POST
+ (NSURLSessionDataTask *)postDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict endBlock:(EndResultBlock)endBlock {
    return [NetworkHelper POST:url parameters:paramDict progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [self initializationDataModelWithTask:task responseObject:responseObject error:error endResult:endBlock];
    }];
}

+ (NSURLSessionDataTask *)postDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict hudTarget:(id)hudTarget endBlock:(EndResultBlock)endBlock {
    return [NetworkHelper POST:url parameters:paramDict hudTarget:hudTarget progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [self initializationDataModelWithTask:task responseObject:responseObject error:error endResult:endBlock];
    }];
}

/*
+ (NSURLSessionDataTask *)postDataWithOperation:(NSString *)operation parameters:(NSDictionary *)paramDict endBlock:(EndResultBlock)endBlock {
    return [NetworkHelper POST:PAIREACH_BASE_URL parameters:paramDict progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [self initializationDataModelWithTask:task responseObject:responseObject error:error endResult:endBlock];
    }];
}

+ (NSURLSessionDataTask *)postDataWithOperation:(NSString *)operation parameters:(NSDictionary *)paramDict hudTarget:(id)hudTarget endBlock:(EndResultBlock)endBlock {
    return [NetworkHelper POST:PAIREACH_BASE_URL parameters:paramDict hudTarget:hudTarget progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        return [NetworkHelper POST:PAIREACH_BASE_URL parameters:paramDict hudTarget:hudTarget progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
            [self initializationDataModelWithTask:task responseObject:responseObject error:error endResult:endBlock];
        }];
    }];
}
 */


//Model数据的初始化
+ (void)initializationDataModelWithTask:(NSURLSessionDataTask *)task
                         responseObject:(id)responseObject
                                  error:(NSError *)error
                              endResult:(EndResultBlock)endResult
{
    if (!endResult) {
        return;
    }
    
    if (!error) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            id model = [[self class] new];
            [model setValue:[self getModelsWithDicts:responseObject] forKey:@"modelListArr"];
            endResult(task, model, nil);
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            id model = [self getModelWithDict:responseObject];
            endResult(task, model, nil);
        } else {
            endResult(task, responseObject, nil);
        }
    } else {
        endResult(task, nil, error);
    }
}

//密码MD5加密
+ (NSString *)md5HexDigest:(NSString *)text {
    const char *original_str = [text UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    /*
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
     */
    
    NSData *data = [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
//    Base64转码
    return [data base64EncodedStringWithOptions:0];
}

/**
 根据接口的Operation名称获取模块名称

 @param operation 当前接口名称
 @return 获取的模块名称
 */
+ (NSString *)getModuleStrWithOperation:(NSString *)operation {
    NSDictionary *moduleDict = @{
                                 APP_USER_SERVICE_MODULE:@[USER_LOGIN_API,
                                                           CHANGE_PASSWORD_API
                                                           ],
                                 APP_ORDER_SERVICE_MODULE:@[QRCODE_SCAN_API],
                                 LOAD_DISCH_GOODS_MODULE:@[QUERY_ORDER_LIST_API,
                                                           ORDER_INFO_SUBMIT_API,
                                                           FACT_LOAD_LIST_API,
                                                           FACT_DISH_LIST_API]
                                 };
    NSArray *keysArr = [moduleDict allKeys];
    for (NSString *key in keysArr) {
        NSArray *operationArr = [moduleDict objectForKey:key];
        for (NSString *tempOperation in operationArr) {
            if ([operation isEqualToString:tempOperation]) {
                return key;
            }
        }
    }
    return @"";
}

/*
+ (NSString *)securityProcessingWithContent:(NSString *)content {
    CocoaSecurityResult *md5Result = [CocoaSecurity md5:content];
    if (md5Result.data.length > 0) {
        return [md5Result.data base64EncodedStringWithOptions:0];
    }
    return content;
}
 */


/*
 {
    sign : 密文,
    parameter : {
                "module" : "appUserService",
                "operation" : "appUserLogin",
                "requestEntity" : {
                                    "account" : "000000",
                                    "password" : "123456"
                                   },
                },
 }
 */


/**
 对参数进行处理，供后台对接口数据进行校验

 @param operation 当前请求的接口
 @param requestEntityDict 当前需要接口对应的真实参数
 @return 返回处理好的参数结果
 */
+ (NSDictionary *)parametersTransformationWithOperation:(NSString *)operation requestEntityDict:(NSDictionary *)requestEntityDict {
    NSString *moduleStr = [self getModuleStrWithOperation:operation];
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *tempDict = @{MODULE_KEY:moduleStr,
                               OPERATION_KEY:operation,
                               REQUESTENTITY_KEY:requestEntityDict,
                               APPVERSION_KEY:versionStr,
                               APPTYPE_KEY:@"iOS",
                               APPSYSTEM_KEY:[UIDevice currentDevice].systemVersion,
                               LIMIT_KEY: requestEntityDict[@"limit"]? requestEntityDict[@"limit"]:@0,
                               START_KEY:requestEntityDict[@"limit"]? requestEntityDict[@"limit"]:@0
                               };
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tempDict options:0 error:&error];
    if (error) {
        return nil;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *tempStr = [NSString stringWithFormat:@"%@%@", jsonStr, SECURITY_KEY];
    NSString *signStr1 = [self md5HexDigest:tempStr];
    NSDictionary *transDict = @{SIGN_KEY:signStr1,
                                    PARAMETER_KEY:jsonStr
                                    };
        return transDict;
}

/**
 对参数进行处理，供后台对接口数据进行校验
 
 @param requestEntityDict 当前需要接口对应的真实参数
 @return 返回处理好的参数结果
 */
+ (NSDictionary *)parametersTransformationWithRequestEntityDict:(NSDictionary *)requestEntityDict {
    NSString *operationStr = [requestEntityDict objectForKey:OPERATION_KEY];
    if (operationStr.length > 0) {
        return [self parametersTransformationWithOperation:operationStr requestEntityDict:requestEntityDict];
    }
    return @{};
}

//网络接口请求添加签名参数sign  ?不起作用啊
+ (NSDictionary *)signReqParams:(NSDictionary *)paramDict {
    if (!paramDict) {
        return nil;
        //return [NSDictionary dictionary];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    [dict setValue:[NSString stringWithFormat:@"%.0f", time] forKey:@"timestamp"];
    [dict setValue:SERVERKEY forKey:@"key"];
    
    NSArray *keyArr = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSString *resStr = @"";
    for(NSString *key in keyArr){
        resStr = [[NSString alloc] initWithFormat:@"%@&%@=%@",resStr,key,[dict objectForKey:key]];
    }
    resStr = [resStr substringFromIndex:1];
    
    const char *cStr = [resStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *md5Sign = [NSString stringWithFormat:
                         @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                         result[0], result[1], result[2], result[3],
                         result[4], result[5], result[6], result[7],
                         result[8], result[9], result[10], result[11],
                         result[12], result[13], result[14], result[15]
                         ];
    
    [dict removeObjectForKey:@"key"];
    //[dict removeObjectForKey:@"timestamp"];
    
    [dict setObject:md5Sign forKey:@"sign"];
    
    return dict;
}

//获取MAC地址
+ (NSString *)getMacAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    //MAC地址带冒号
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2),
                           *(ptr+3), *(ptr+4), *(ptr+5)];
    
    //    // MAC地址不带冒号
    //    NSString *outstring = [NSString
    //                           stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}

//获取设备型号
+ (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

//计算文字高度
+ (CGFloat)heightForTextString:(NSString *)tStr width:(CGFloat)tWidth fontSize:(CGFloat)tSize {
    NSString *tempStr = [NSString stringWithFormat:@"%@", tStr];
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:tSize]};
    CGRect rect = [tempStr boundingRectWithSize:CGSizeMake(tWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height;
}

//计算文字宽度
+ (CGFloat)widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize {
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:tSize]};
    CGRect rect = [tStr boundingRectWithSize:CGSizeMake(MAXFLOAT, tHeight) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width + 5.0;
}



/**
 获取网络运营商的IMSI

 @return IMSI
 */
+ (NSString *)getIMSI {
    NSString *mcc = [self getMobileCountryCode];
    NSString *mnc = [self getMobileNetworkCode];
    NSString *imsi = [NSString stringWithFormat:@"%@%@", mcc, mnc];
    return imsi.length>0? imsi:@"";
}


/**
 获取SIM卡国家编码

 @return MCC
 */
+ (NSString *)getMobileCountryCode {
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mcc = [carrier mobileCountryCode];
    return mcc.length>0? mcc:@"";
}


/**
 获取手机网络运营商编码

 @return MNC
 */
+ (NSString *)getMobileNetworkCode {
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mnc = [carrier mobileNetworkCode];
    return mnc.length>0? mnc:@"";
}

/**
 获取CarrierName
 
 @return name
 */
+ (NSString *)getCarrierName {
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *name = [carrier carrierName];
    return name.length>0? name:@"";
}


/**
 添加本地通知

 @param contentStr 需要提示的通知内容
 @param identifier 通知的唯一标识
 @param interval 通知重复执行的时间间隔
 */
+ (void)addLocalNotificationWithContent:(NSString *)contentStr identifier:(NSString *)identifier repeatInterval:(NSTimeInterval)interval {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.body = [NSString localizedUserNotificationStringForKey:contentStr arguments:nil];
        content.sound = [UNNotificationSound defaultSound];
        if (interval > 0) {            
            UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:interval repeats:YES];
            
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger1];
            
            //添加推送成功后的处理！
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"本地通知添加成功");
                }
            }];
        } else {
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:nil];
            
            //添加推送成功后的处理！
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"本地通知添加成功");
                }
            }];
        }
    } else if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.alertBody = [NSString stringWithFormat:@"%@", contentStr];
        if (interval > 0) {
            localNotif.repeatInterval = interval;
        } else {
            localNotif.repeatInterval = 0;
        }
        //        localNotif.hasAction = NO;
        //注意 ：  这里是立刻弹出通知，其实这里也可以来定时发出通知，或者倒计时发出通知
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    }
}


/**
 移除相应的通知

 @param identifier 需要移除的通知的唯一标识
 */
+ (void)removePendingLocalNotificationWithIdentifier:(NSString *)identifier {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
//        [center removeDeliveredNotificationsWithIdentifiers:@[identifier]];
    } else if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}


/**
 移除所有的通知
 */
+ (void)removeAllPendingLocalNotification {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeAllPendingNotificationRequests];
//        [center removeAllDeliveredNotifications];
    } else if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}


@end
