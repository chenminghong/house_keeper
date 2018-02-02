//
//  PaireachAPI.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#ifndef PaireachAPI_h
#define PaireachAPI_h

//网络请求加密秘钥
#define SECURITY_KEY                      @"ApKKT6/wmftRRLh9aAd+lg=="   //MD5加密秘钥

//网络请求参数关键字
#define SIGN_KEY                          @"sign"               //密文
#define PARAMETER_KEY                     @"parameter"          //请求参数
#define MODULE_KEY                        @"module"             //模块
#define OPERATION_KEY                     @"operation"          //操作类型
#define REQUESTENTITY_KEY                 @"requestEntity"      //实际操作参数
#define APPVERSION_KEY                    @"appversion"         //APP版本
#define APPTYPE_KEY                       @"apptype"            //app类型
#define APPSYSTEM_KEY                     @"appsystem"          //app的系统类型
#define LIMIT_KEY                         @"limit"              //每页限制数量
#define START_KEY                         @"start"              //每页开始位置

//网络请求数据解析关键字
#define RESULT_FLAG_KEY                   @"resultFlag"         //请求成功标识
#define MESSAGE_KEY                       @"message"            //请求成功失败提示语句
#define RESPONSE_ENTITY_KEY               @"responseEntity"     //供界面显示使用的Data数据


#pragma markk -- APP接口定义

/*============================BaseUrl相关=============================*/
//API前缀定义
#define BASE_URL                @"http://139.196.188.185:8385/itip-app-web"    //线上测试
//#define BASE_URL                @"http://192.168.0.158:8283/itip-app-web"   //Ocean本地
//#define BASE_URL                @"http://dt.paireach.com/itip/client/"       //双至域名

//改版APP数据请求接口
#define PAIREACH_NETWORK_URL                 @"mobileDispatch/index.html"    //流程操作相关URL



/*============================首页相关=============================*/
//APP接口服务模块类型
#define APP_ORDER_SERVICE_MODULE           @"driverVehicleService"           //post

//首页数据显示
#define HOME_PAGE_DATA_API                 @"homePageDisplay.a"              //get

//一维码扫描接口
#define QRCODE_SCAN_API                    @"driverProcessOperation"         //get

//下一步订单校验
#define HOME_ORDER_CHECK_API               @"queryDriverInfoByCode.a"        //post

//提交司机信息
#define COMMIT_DRIVERINFO_API              @"orderSince.a"                   //post



/*============================个人中心用户相关=============================*/
//APP接口服务类型
#define APP_USER_SERVICE_MODULE            @"appUserService"

//用户登录
#define USER_LOGIN_API                     @"appUserLogin"                    //post

//修改密码
#define CHANGE_PASSWORD_API                @"changeDriverPwd.a"               //post


/*============================排队中心用户相关=============================*/

//排队中心模块
#define LOAD_DISCH_GOODS_MODULE            @"loadDischGoodsService"

//门岗信息录入运单查询
#define QUERY_ORDER_LIST_API               @"mengGangQueryOrderInfo"            //post

//门岗信息录入运单提交
#define ORDER_INFO_SUBMIT_API              @"mengGangOrderInfoSubmit"           //post

//APP门岗-装货队列接口
#define FACT_LOAD_LIST_API                 @"menGangFactLoadList"               //post

//APP门岗-其他装卸货队列接口
#define FACT_DISH_LIST_API                 @"menGangFactDishList"               //post







/*============================通知中心相关=============================*/

#pragma mark -- 通知中心

//订单中心刷新通知
#define ORDERSCENTER_RELOAD_NAME            @"order_center_reloaddata"







#endif /* PaireachAPI_h */
