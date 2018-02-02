//
//  LoginModel.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "LoginModel.h"

#import <CommonCrypto/CommonDigest.h>

@implementation LoginModel

//初始化
+ (instancetype)shareLoginModel {
    static LoginModel *loginModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginModel = [LoginModel new];
    });
    return loginModel;
}

//初始化数据
- (void)initData {
    NSDictionary *userInfo = [LoginModel readUserInfo];
    if (userInfo) {
        [self setValuesForKeysWithDictionary:userInfo];
    }
    
    if (self.fullName && self.phone) {
        NSString *name = [NSString stringWithFormat:@"%@_%@", [LoginModel shareLoginModel].fullName, [LoginModel shareLoginModel].phone];
                
        //开启友盟账号登录
        [MobClick profileSignInWithPUID:name];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"userRelationMap"]) {
        NSDictionary *tempDict = value;
        NSArray *infoArr = tempDict[@"source"];
        if (infoArr.count > 0) {
            NSDictionary *sourceDict = [infoArr objectAtIndex:0];
            _code = sourceDict[@"code"];
            _name = sourceDict[@"name"];
        }
    } else {
        [super setValue:value forKey:key];
    }
}

- (NSString *)phone {
    if (_phone.length <= 0) {
        return @"";
    }
    return _phone;
}

- (NSString *)account {
    if (_account.length <= 0) {
        return @"";
    }
    return _account;
}

- (NSString *)code {
    if (_code.length <= 0) {
        return @"";
    }
    return _code;
}

+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict endBlock:(EndResultBlock)endBlock {
    return [NetworkHelper POST:url parameters:paramDict progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (endBlock) {
            if (!error) {
                //将登录成功返回的数据存到model中
                [[LoginModel shareLoginModel] updateUserInfoWithInfoDict:responseObject];
                endBlock(task, [LoginModel shareLoginModel], nil);
            } else {
                endBlock(task, nil, error);
            }
        }
    }];
}

+ (NSURLSessionDataTask *)getDataWithUrl:(NSString *)url parameters:(NSDictionary *)paramDict hudTarget:(id)hudTarget endBlock:(EndResultBlock)endBlock {
    return [NetworkHelper POST:url parameters:paramDict hudTarget:hudTarget progress:nil endResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (endBlock) {
            if (!error) {
                //将登录成功返回的数据存到model中
                [[LoginModel shareLoginModel] updateUserInfoWithInfoDict:responseObject];
                endBlock(task, [LoginModel shareLoginModel], nil);
            } else {
                endBlock(task, nil, error);
            }
        }
    }];
}

//更新全部用户信息
- (void)updateUserInfoWithInfoDict:(NSDictionary *)infoDict {
    [self setValuesForKeysWithDictionary:infoDict];
    [self saveUserInfo:infoDict];
}

//修改某一条信息
+ (void)updateInfoValue:(NSString *)infoValue forKey:(NSString *)key {
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithDictionary:[self readUserInfo]];
    [infoDict setValue:infoValue forKey:key];
    [[LoginModel shareLoginModel] updateUserInfoWithInfoDict:infoDict];
}

//是否登录
+ (BOOL)isLoginState {
    return [[NSUserDefaults standardUserDefaults] boolForKey:LOGIN_STATE];
}

//保存用户信息数据
- (void)saveUserInfo:(NSDictionary *)userInfo {
    NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [FileHelper writeUserDefault:USER_INFO andValue:infoData];
}

//读取用户信息数据
+ (NSDictionary *)readUserInfo {
    NSData *userData = [FileHelper readUserDefaultWithKey:USER_INFO];
    if (userData) {
        NSDictionary *userInfoDict = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        return userInfoDict;
    }
    return nil;
}


@end
