//
//  BaseModelMethod.m
//  JewelryApp
//
//  Created by kequ on 15/5/17.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "BaseModelMethod.h"

@implementation BaseModelMethod

+ (NSArray *)getGoodsArrayFromDicInfo:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]] || !array.count) {
        return nil;
    }
    NSMutableArray * fArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * info in array) {
        GoodsModel * goodsModel = [GoodsModel coverDicToGoodsModel:info];
        if (goodsModel) {
            [fArray addObject:goodsModel];
        }
    }
    return fArray;
}

+ (NSArray *)getFactoryArrayFromDicInfo:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]] || !array.count) {
        return nil;
    }
    NSMutableArray * fArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * info in array) {
        FactoryModel * goodsModel = [FactoryModel coverDicToModel:info];
        if (goodsModel) {
            [fArray addObject:goodsModel];
        }
    }
    return fArray;
}

+ (NSArray*)getCatergoryIntoWithInfo:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]] || !array.count) {
        return nil;
    }
    NSMutableArray * catgoryTag = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * info in array) {
        GoodsCategoryModel * cModel = [GoodsCategoryModel converDicInfoToModel:info];
        if (cModel) {
            [catgoryTag addObject:cModel];
        }
    }
    return [catgoryTag copy];
}

+ (NSArray *)getOrderListArrayFormDicInfo:(NSArray *)array cellType:(KOrderCellType)type
{
    if (![array isKindOfClass:[NSArray class]] || !array.count) {
        return nil;
    }
    NSMutableArray * oArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * info in array) {
        OrderModel * orderModel = [OrderModel converDicInfoToModel:info cellType:type];
        if (orderModel) {
            [oArray addObject:orderModel];
        }
    }
    return [oArray copy];
}
@end
