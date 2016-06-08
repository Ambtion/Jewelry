//
//  RecomendGoogsModel.m
//  JewelryApp
//
//  Created by kequ on 15/5/2.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "GoodsCategoryModel.h"

@implementation GoodsCategoryModel

+ (GoodsCategoryModel *)converDicInfoToModel:(NSDictionary *)info
{
    if (![info allKeys]) {
        return nil;
    }
    GoodsCategoryModel * model = [[GoodsCategoryModel alloc] init];
    model.categoryID = [info objectForKey:@"category_id"];
    model.categoryImageStr = [info objectForImageStr:@"image"];
    model.categoryKeyWorld = [info objectForKey:@"category_name"];
    return model;
}
@end
