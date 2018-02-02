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
        self.isFolded = NO;
    }
    return self;
}


- (void)setCuiList:(NSMutableArray *)cuiList {
    _cuiList = [NSMutableArray arrayWithArray:[[self class] getModelsWithDicts:cuiList]];
}

- (void)setOutList:(NSMutableArray *)outList {
    _outList = [NSMutableArray arrayWithArray:[[self class] getModelsWithDicts:outList]];
}

- (void)setReadList:(NSMutableArray *)readList {
    readList = [NSMutableArray arrayWithArray:[[self class] getModelsWithDicts:readList]];
}

@end
