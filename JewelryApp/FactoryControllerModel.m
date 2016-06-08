//
//  FactoryAllInfoModel.m
//  JewelryApp
//
//  Created by kequ on 15/5/17.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "FactoryControllerModel.h"
#import "GoodsModel.h"

@implementation FactoryControllerModel

- (NSArray *)getArrayForRecomendArray:(NSArray *)recoemArray
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:recoemArray.count];
    for (GoodsModel * rModel in recoemArray) {
        if (rModel.goodsImageArry && rModel.goodsImageArry.count) {
            [array addObject:[rModel.goodsImageArry firstObject]];
        }else{
            [array addObject:@""];
        }
    }
    return array;
}

@end
