//
//  BaseModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WarehouseType) {
    WarehouseTypeInside = 10,
    WarehouseTypeOutside,
};


@interface BaseModel : NSObject

@property (nonatomic, strong) NSArray *modelListArr;   //存储本类Model数据对象的数组


/******************************Model数据模型初始化********************************/

//初始化Model
- (instancetype)initWithDict:(NSDictionary *)dict;

//初始化Model
+ (instancetype)getModelWithDict:(NSDictionary *)dict;

//初始化Model
+ (NSArray *)getModelsWithDicts:(NSArray *)dicts;


/******************************数据请求********************************/
//GET
+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict endBlock:(EndResultBlock)endBlock;

+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict hudTarget:(id)hudTarget endBlock:(EndResultBlock)endBlock;

//+ (NSURLSessionDataTask *)getDataWithOperation:(NSString *)operation parameters:(NSDictionary *)paramDict endBlock:(EndResultBlock)endBlock;

//+ (NSURLSessionDataTask *)getDataWithOperation:(NSString *)operation parameters:(NSDictionary *)paramDict hudTarget:(id)hudTarget endBlock:(EndResultBlock)endBlock;

//POST
+ (NSURLSessionDataTask *)postDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict endBlock:(EndResultBlock)endBlock;

+ (NSURLSessionDataTask *)postDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict hudTarget:(id)hudTarget endBlock:(EndResultBlock)endBlock;

//+ (NSURLSessionDataTask *)postDataWithOperation:(NSString *)operation parameters:(NSDictionary *)paramDict endBlock:(EndResultBlock)endBlock;

//+ (NSURLSessionDataTask *)postDataWithOperation:(NSString *)operation parameters:(NSDictionary *)paramDict hudTarget:(id)hudTarget endBlock:(EndResultBlock)endBlock;


/******************************接口参数处理********************************/

//网络接口请求添加签名参数sign  ?不起作用啊
+ (NSDictionary *)signReqParams:(NSDictionary *)paramDict;

//密码MD5加密(Base64转码)
+ (NSString *)md5HexDigest:(NSString *)text;

/**
 对参数进行处理，供后台对接口数据进行校验
 
 @param operation 当前请求的接口
 @param requestEntityDict 当前需要接口对应的真实参数
 @return 返回处理好的参数结果
 */
+ (NSDictionary *)parametersTransformationWithOperation:(NSString *)operation requestEntityDict:(NSDictionary *)requestEntityDict;

/**
 对参数进行处理，供后台对接口数据进行校验
 
 @param requestEntityDict 当前需要接口对应的真实参数
 @return 返回处理好的参数结果
 */
+ (NSDictionary *)parametersTransformationWithRequestEntityDict:(NSDictionary *)requestEntityDict;


/******************************获取数据基础数据********************************/

//获取MAC地址
+ (NSString *)getMacAddress;

//获取设备型号
+ (NSString *)iphoneType;

//计算文字的高度(定宽)
+ (CGFloat)heightForTextString:(NSString *)tStr width:(CGFloat)tWidth fontSize:(CGFloat)tSize;

//计算文字的宽度(定高)
+ (CGFloat)widthForTextString:(NSString *)tStr height:(CGFloat)tHeight fontSize:(CGFloat)tSize;

/**
 获取网络运营商的IMSI
 
 @return IMSI
 */
+ (NSString *)getIMSI;

/**
 获取SIM卡国家编码
 
 @return MCC
 */
+ (NSString *)getMobileCountryCode;

/**
 获取SIM卡信息运营商编码
 
 @return MNC
 */
+ (NSString *)getMobileNetworkCode;

/**
 获取CarrierName
 
 @return name
 */
+ (NSString *)getCarrierName;

/**
 添加本地通知
 
 @param contentStr 需要提示的通知内容
 @param identifier 通知的唯一标识
 @param interval 通知重复执行的时间间隔
 */
+ (void)addLocalNotificationWithContent:(NSString *)contentStr identifier:(NSString *)identifier repeatInterval:(NSTimeInterval)interval;

/**
 移除相应的通知
 
 @param identifier 需要移除的通知的唯一标识
 */
+ (void)removePendingLocalNotificationWithIdentifier:(NSString *)identifier;

/**
 移除所有的通知
 */
+ (void)removeAllPendingLocalNotification;

@end

