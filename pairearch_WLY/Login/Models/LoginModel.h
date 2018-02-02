//
//  LoginModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface LoginModel : BaseModel

@property (nonatomic, copy) NSString *account;      //登录账号

@property (nonatomic, copy) NSString *userCode;     //用户编码

@property (nonatomic, copy) NSString *headImg;      //用户头像

@property (nonatomic, copy) NSString *fullName;     //用户姓名

@property (nonatomic, copy) NSString *idCard;       //身份证

@property (nonatomic, copy) NSString *phone;        //手机号码

@property (nonatomic, copy) NSString *createDate;   //创建时间

@property (nonatomic, copy) NSString *code;         //工厂编码

@property (nonatomic, copy) NSString *name;         //门岗工厂名称


//初始化
+ (instancetype)shareLoginModel;

//是否登录
+ (BOOL)isLoginState;

//初始化数据
- (void)initData;

//更新用户信息数据
- (void)updateUserInfoWithInfoDict:(NSDictionary *)infoDict;

//修改某一条信息
+ (void)updateInfoValue:(NSString *)infoValue forKey:(NSString *)key;


@end
