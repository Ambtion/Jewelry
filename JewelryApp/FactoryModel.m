//
//  FactoryModel.m
//  JewelryApp
//
//  Created by kequ on 15/5/2.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "FactoryModel.h"
#import "GoodsModel.h"

@implementation FactoryModel

+ (FactoryModel *)coverDicToModel:(NSDictionary *)dic
{
    if (!dic || ![dic allKeys].count) {
        return nil;
    }
    
    FactoryModel * model = [[FactoryModel alloc] init];
    
    model.factoryId = [dic objectStringForKey:@"supplier_id"];
    model.factoryName = [dic objectStringForKey:@"supplier_code"];
    model.bgImageView = [dic objectForImageStr:@"background"];
    model.iconImageView = [dic objectForImageStr:@"icon"];
    model.facroyDes = [dic objectStringForKey:@"supplier_info"];
    model.factoryTel = [dic objectStringForKey:@"tel400"];
    model.factoryGoodsNum = [[dic objectForKey:@"goods_count"] intValue];
    model.lastestGoodsNum = [[dic objectForKey:@"new_count"] intValue];
    model.isFav = [[dic objectForKey:@"is_focus"] boolValue];
    return model;

}

@end
