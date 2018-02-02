//
//  OrderListModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface OrderListModel : BaseModel

@property (nonatomic, copy) NSString *plateNumber;   //车牌号

@property (nonatomic, assign) BOOL isFolded;   //是否折叠起来


/*
 active = Y;
 code = LP494;
 createDate = 1516430939000;
 deliveryType = 1;
 driverName = "\U5b89\U5409";
 driverTel = 13212345688;
 estiIntoFactTime = 1516433011000;
 id = 647;
 intoFacotryTime = 1516445011000;
 limit = 0;
 loadLeaveTime = 10;
 loadTime = 15;
 loadType = t;
 modifyDate = 1516430957000;
 occupyReleaseWharf = Y;
 planLoadDate = 1516377600000;
 queue = 2997714;
 readyLoadTime = 10;
 releaseNode = w;
 signTime = 1516430958000;
 sourceCode = SC7;
 splitSource = sap;
 spotAppoint = Y;
 spotLineUp = Y;
 spotPda = N;
 start = 0;
 statusCode = 135;
 statusName = "\U50ac\U4fc3\U5165\U5382";
 tuCode = 012010005A;
 vehicleNumber = "\U6caaA00005";
 vehicleType = 53;
 wharfId = 10066;
 wharfName = "\U4fa7\U5e18";
 */

@property (nonatomic, strong) NSMutableArray *cuiList;  //催促入厂

@property (nonatomic, copy) NSString *vehicleNumber;    //车牌号

@property (nonatomic, copy) NSString *intoFacotryTime;  //入厂时间


/*
 active = Y;
 appoinStartTime = 1516421400000;
 appointEndTime = 1516422000000;
 code = LP493;
 createDate = 1516430292000;
 deliveryType = 1;
 driverName = "\U738b\U4f1f\U4f1f";
 driverTel = 13212345678;
 estiIntoFactTime = 1516430340000;
 id = 646;
 intoFacotryTime = 0;
 limit = 0;
 loadLeaveTime = 10;
 loadTime = 5;
 loadType = t;
 modifyDate = 1516430340000;
 occupyReleaseWharf = Y;
 planLoadDate = 1516377600000;
 queue = 3999815;
 readyLoadTime = 5;
 releaseNode = w;
 signStatus = cd;
 signTime = 1516430340000;
 sourceCode = SC7;
 splitSource = sap;
 spotAppoint = Y;
 spotLineUp = Y;
 spotPda = N;
 start = 0;
 statusCode = 123;
 statusName = "\U6392\U961f\U5ba1\U6838";
 tuCode = 012010002A;
 vehicleNumber = "\U6caaA00002";
 vehicleType = 50;
 wharfId = 10066;
 wharfName = "\U4fa7\U5e18";
 */


@property (nonatomic, strong) NSMutableArray *outList;  //

@property (nonatomic, strong) NSMutableArray *readList;

@end
