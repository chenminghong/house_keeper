//
//  OrderListModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface OrderListModel : BaseModel

@property (nonatomic, copy) NSString *plateNumber;   //运单开始时间

@property (nonatomic, strong) NSMutableArray *flateModelArr;  //车牌号数组



@end
