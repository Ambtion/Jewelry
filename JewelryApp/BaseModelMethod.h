//
//  BaseModelMethod.h
//  JewelryApp
//
//  Created by kequ on 15/5/17.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel+UploadorModify.h"
#import "FactoryModel.h"
#import "OrderModel.h"

@interface BaseModelMethod : NSObject
+ (NSArray *)getGoodsArrayFromDicInfo:(NSArray *)array;
+ (NSArray *)getFactoryArrayFromDicInfo:(NSArray *)array;
+ (NSArray *)getCatergoryIntoWithInfo:(NSArray *)array;
+ (NSArray *)getOrderListArrayFormDicInfo:(NSArray *)array cellType:(KOrderCellType)type;
@end
